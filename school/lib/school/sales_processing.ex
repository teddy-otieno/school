defmodule School.SalesProcessing do
  import Ecto.Query, warn: false
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
    items = Ecto.Changeset.get_field(changeset, :items)
    product_checks = Enum.map(items, &is_product_selable?/1)

    unless Enum.all?(product_checks) do
      {:invalid_quantity, "Item has invalid quantity"}
    else
      # Begin trnasfer
      initiate_transaction(changeset)
    end
  end

  def initiate_transaction(%Ecto.Changeset{changes: changes}) do
    Multi.new()
    |> Multi.run(:original_changes, fn _, _ -> {:ok, changes} end)
    |> Multi.insert(:sale_order, &insert_sale_order/1)
    |> Multi.run(:items_to_be_sold, fn _, _ -> {:ok, changes.items} end)
    |> Multi.run(:order_details, &load_orders_with_prices/2)
    |> Multi.insert_all(:inserted_order_items, SaleOrderDetails, &get_order_details/1)
    |> Multi.insert(:invoice, &insert_invoice/1)
    |> Multi.run(:student_account, &get_student_account/2)
    |> Multi.run(:vendor_account, &get_vendor_account/2)
    |> Multi.insert(:student_debit, &insert_student_debit/1)
    |> Multi.insert(:vendor_credit, &insert_vendor_credit/1)
    |> Multi.insert(:journal, &insert_journal_entry/1)
    |> Multi.insert_all(:stock_move, StockMovement, &move_stock/1)
    |> Repo.transaction()
  end

  defp insert_invoice(%{sale_order: sale_order}) do
    SaleInvoice.changeset(%SaleInvoice{sales_order_id: sale_order.id}, %{})
  end

  defp get_order_details(%{order_details: order_details}) do
    order_details
  end

  defp insert_sale_order(%{original_changes: changes}) do
    SaleOrder.changeset(%SaleOrder{}, %{
      "student_id" => changes.student_id,
      "vendor_id" => changes.vendor_id,
      "memo" => changes.memo,
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
      from(v in Vendor, where: v._type == :vendor and v.acc_owner == ^changes.vendor_id)
      |> repo.one!()

    {:ok, vendor_account}
  end

  @doc """
    ordered_items - items inserted to the database i.e SaleOrderDetails
    items - items received from the user i.e ItemsToBeSold
  """
  defp compute_total_amount_for_items(ordered_items, items) do
    ordered_items
    |> Enum.reduce(0, fn %SaleOrderDetails{} = x, acc ->
      ordered_details_with_product = Repo.preload(x, [:product])

      quantity_being_sold =
        items
        |> Enum.find_value(fn x ->
          if(x.product_id == ordered_details_with_product.product_id, do: x.quantity, else: nil)
        end)

      if(is_nil(quantity_being_sold),
        do: raise(RuntimeError, "Quantity is required. Data received might be invalid")
      )

      x.product.price
      |> Money.multiply(quantity_being_sold)
      |> Money.add(acc)
    end)
  end

  defp insert_vendor_credit(%{
         inserted_order_items: ordered_items,
         vendor_account: vendor_account,
         items_to_be_sold: items
       }) do
    %AccountTransactions{
      debit: Money.new(0),
      credit: compute_total_amount_for_items(ordered_items, items),
      account_id: vendor_account.id
    }
  end

  defp insert_student_debit(%{
         inserted_order_items: ordered_items,
         student_account: s_account,
         items_to_be_sold: items
       }) do
    AccountTransactions.changeset(
      %AccountTransactions{
        debit: compute_total_amount_for_items(ordered_items, items),
        credit: Money.new(0),
        account_id: s_account.id
      },
      %{}
    )
  end

  @spec insert_journal_entry(%{
          student_debit: %AccountTransactions{},
          vendor_credit: %AccountTransactions{}
        }) :: %Ecto.Changeset{}
  defp insert_journal_entry(%{student_debit: debit, vendor_credit: credit}) do
    Journal.changeset(
      %Journal{
        debit_trans: debit.id,
        credit_trans: credit.id,
        description: "Commodity Purchase"
      },
      %{}
    )
  end

  @spec move_stock(%{items_to_be_sold: list(%ItemsToBeSold{})}) ::
          list(%{product_id: integer(), quantity: integer(), comment: binary()})
  defp move_stock(%{items_to_be_sold: items}) do
    items
    |> Enum.map(fn x ->
      %{product_id: x.product_id, quantity: x.quantity, comment: "Commodity Sold"}
    end)
  end

  defp load_orders_with_prices(repo, %{sales_order: sale_order, items_to_be_sold: items}) do
    # NOTE: (teddy) Fetch al orders with prices
    order_items =
      items
      |> Enum.map(fn %ItemsToBeSold{} = x ->
        product = from(p in Product, where: p.id == ^x.id) |> repo.one()

        %SaleOrderDetails{
          product_id: product.id,
          purchase_price: product.price,
          sales_order_id: sale_order.id
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
