defmodule School.SalesProcessing do
  import Ecto.Query, warn: false
  alias SchoolWeb.Vendors.DirectSaleSchema
  alias School.Money.Journal
  alias Ecto.Multi

  alias School.Repo
  alias School.Money.{AccountTransactions, Account}

  alias School.School.Vendor
  alias School.Vendors.Product
  alias School.Vendors.StockMovement
  alias School.SalesProcessing.{SaleOrder, SaleInvoice, SaleOrderDetails}

  alias SchoolWeb.Vendors.ItemsToBeSold

  def initiate_direct_sale(%Ecto.Changeset{valid?: true} = changeset) do
    # Check if the quantities are available
    %DirectSaleSchema{} = sale = Ecto.Changeset.apply_changes(changeset) |> dbg
    items = Ecto.Changeset.get_field(changeset, :items)
    product_checks = Enum.map(items, &is_product_selable?/1)

    unless Enum.all?(product_checks) do
      {:invalid_quantity, "Item has invalid quantity"}
    else
      # Begin trnasfer
      initiate_transaction(sale)
    end
  end

  def initiate_transaction(%DirectSaleSchema{} = sale) do
    Multi.new()
    |> Multi.run(:original_changes, fn _, _ -> {:ok, sale} end)
    |> Multi.insert(:sale_order, &insert_sale_order/1)
    |> Multi.run(:items_to_be_sold, fn _, _ -> {:ok, sale.items} end)
    |> Multi.run(:order_details, &load_orders_with_prices/2)
    |> Multi.insert_all(:inserted_order_items, SaleOrderDetails, &get_order_details/1,
      returning: true
    )
    |> Multi.insert(:invoice, &insert_invoice/1)
    |> Multi.run(:student_account, &get_student_account/2)
    |> Multi.run(:vendor_account, &get_vendor_account/2)
    |> Multi.insert(:student_credit, &insert_student_credit/1)
    |> Multi.insert(:vendor_debit, &insert_vendor_debit/1)
    |> Multi.insert(:journal, &insert_journal_entry/1)
    |> Multi.insert_all(:stock_move, StockMovement, &move_stock/1, returning: true)
    |> Multi.run(:total_sale_value, &compute_total_order_value/2)
    |> Repo.transaction()
  end

  defp compute_total_order_value(repo, %{sale_order: sale_order}) do
    query =
      from(order_details in SaleOrderDetails,
        where: ^sale_order.id == order_details.sales_order_id,
        select:
          fragment("sum((?).amount * ?)", order_details.purchase_price, order_details.quantity)
      )

    {:ok, repo.one!(query)}
  end

  defp insert_invoice(%{sale_order: sale_order}) do
    SaleInvoice.changeset(%SaleInvoice{sales_order_id: sale_order.id}, %{})
  end

  defp get_order_details(%{order_details: order_details, sale_order: sale_order}) do
    order_details
    |> Enum.map(fn x ->
      %{
        purchase_price: x.purchase_price,
        product_id: x.product_id,
        sales_order_id: x.sales_order_id,
        memo: "",
        inserted_at: sale_order.inserted_at,
        updated_at: sale_order.updated_at,
        quantity: x.quantity
      }
    end)
    |> dbg
  end

  @spec insert_sale_order(%{original_changes: %DirectSaleSchema{}}) :: any()
  defp insert_sale_order(%{original_changes: changes}) do
    SaleOrder.changeset(%SaleOrder{}, %{
      "student_id" => changes.student_id,
      "vendor_id" => changes.vendor_id,
      "memo" => if(Map.has_key?(changes, :memo), do: changes.memo, else: ""),
      "timestamp" => changes.timestamp
    })
  end

  defp get_student_account(repo, %{original_changes: changes}) do
    student_account =
      from(a in Account, where: a._type == :student and a.acc_owner == ^changes.student_id)
      |> repo.one()

    {:ok, student_account}
  end

  defp get_vendor_account(repo, %{original_changes: changes}) do
    vendor_account =
      from(a in Account, where: a._type == :vendor and a.acc_owner == ^changes.vendor_id)
      |> repo.one!()

    {:ok, vendor_account}
  end

  defp compute_total_amount_for_items({_, ordered_items}, items) do
    ordered_items
    |> dbg
    |> Enum.reduce(0, fn %SaleOrderDetails{} = x, acc ->
      ordered_details_with_product = Repo.preload(x, [:product]) |> dbg

      quantity_being_sold =
        items
        |> Enum.find_value(fn x ->
          if(x.product_id == ordered_details_with_product.product_id, do: x.quantity, else: nil)
        end)

      if(is_nil(quantity_being_sold),
        do: raise(RuntimeError, "Quantity is required. Data received might be invalid")
      )

      ordered_details_with_product.product.price
      |> Money.multiply(quantity_being_sold)
      |> Money.add(acc)
    end)
  end

  defp insert_vendor_debit(%{
         inserted_order_items: ordered_items,
         vendor_account: vendor_account,
         items_to_be_sold: items
       }) do
    %AccountTransactions{
      credit: Money.new(0),
      debit: compute_total_amount_for_items(ordered_items, items),
      account_id: vendor_account.id
    }
  end

  defp insert_student_credit(%{
         inserted_order_items: ordered_items,
         student_account: s_account,
         items_to_be_sold: items
       }) do
    AccountTransactions.changeset(
      %AccountTransactions{
        credit: compute_total_amount_for_items(ordered_items, items),
        debit: Money.new(0),
        account_id: s_account.id
      },
      %{}
    )
  end

  @type new_journal_entry() :: %{
          student_credit: %AccountTransactions{},
          vendor_debit: %AccountTransactions{}
        }

  @spec insert_journal_entry(new_journal_entry()) :: %Ecto.Changeset{}
  defp insert_journal_entry(%{student_credit: credit, vendor_debit: debit}) do
    Journal.changeset(
      %Journal{
        debit_trans: debit.id,
        credit_trans: credit.id,
        description: "Commodity Purchase"
      },
      %{}
    )
  end

  @spec move_stock(%{items_to_be_sold: list(%ItemsToBeSold{}), sale_order: %SaleOrder{}}) ::
          list(%{product_id: integer(), quantity: integer(), comment: binary()})
  defp move_stock(%{items_to_be_sold: items, sale_order: sale_order}) do
    items
    |> Enum.map(fn x ->
      %{
        product_id: x.product_id,
        quantity: -x.quantity,
        comment: "Commodity Sold",
        inserted_at: sale_order.inserted_at,
        updated_at: sale_order.updated_at
      }
    end)
  end

  @spec load_orders_with_prices(Repo, %{
          sale_order: %SaleOrder{},
          items_to_be_sold: list(%ItemsToBeSold{})
        }) :: {:ok, list(%SaleOrderDetails{})}
  defp load_orders_with_prices(repo, %{sale_order: sale_order, items_to_be_sold: items}) do
    # NOTE: (teddy) Fetch al orders with prices
    order_items =
      items
      |> Enum.map(fn %ItemsToBeSold{} = x ->
        product = from(p in Product, where: p.id == ^x.product_id) |> repo.one()

        %SaleOrderDetails{
          product_id: product.id,
          purchase_price: product.price,
          sales_order_id: sale_order.id,
          quantity: x.quantity
        }
      end)

    {:ok, order_items}
  end

  defp is_product_selable?(%ItemsToBeSold{product_id: product_id, quantity: quantity}) do
    available_quantity =
      from(movement in StockMovement,
        where: movement.product_id == ^product_id,
        select: sum(movement.quantity)
      )
      |> Repo.one()

    available_quantity - quantity > 0
  end

  def does_product_exist?(product_id) do
    not is_nil(
      from(p in Product, where: p.id == ^product_id)
      |> Repo.one()
    )
  end
end
