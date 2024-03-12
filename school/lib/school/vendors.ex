defmodule School.Vendors do
  import Ecto.Query, warn: false
  alias School.SalesProcessing.SaleOrder
  alias School.Repo

  alias School.Vendors.Product
  alias School.Vendors.StockMovement
  alias School.School.Vendor
  alias School.Accounts.User

  def list_vendor_items(%Vendor{id: id}) do
    query = from(p in Product, where: p.vendor_id == ^id)

    query
    |> Repo.all()
  end

  def get_vendor_from_current_user(%User{id: id}) do
    query = from(v in Vendor, where: v.user_id == ^id)

    query
    |> Repo.one!()
  end

  def create_product_item(%Vendor{id: vendor_id}, attrs, image_path) do
    update_attributes =
      attrs
      |> Map.put("vendor_id", vendor_id)
      |> Map.put("price", Money.new(attrs["price"] * 100))
      |> Map.put("image", image_path)

    %Product{}
    |> Product.changeset(update_attributes)
    |> Repo.insert()
  end

  def create_stock_movement_entry(movement_attrs) do
    %StockMovement{}
    |> StockMovement.changeset(movement_attrs)
    |> Repo.insert()
  end

  def list_stock_quantities(%Vendor{id: vendor_id}) do
    query =
      from(movement in StockMovement,
        inner_join: product in Product,
        on: product.id == movement.product_id and product.vendor_id == ^vendor_id,
        group_by: [product.id],
        select: %{
          quantity: sum(movement.quantity),
          product: product
        }
      )

    Repo.all(query)
  end

  def list_all_products_and_quantities(%Vendor{id: vendor_id}) do
    sum_all_quantities =
      from(movement in StockMovement,
        where: parent_as(:p).id == movement.product_id,
        select: sum(movement.quantity)
      )

    query =
      from(product in Product,
        as: :p,
        where: product.vendor_id == ^vendor_id,
        select: %{
          product: product,
          quantity: fragment("coalesce(?, 0)", subquery(sum_all_quantities))
        }
      )

    Repo.all(query)
  end

  def list_all_complete_sales(%Vendor{id: vendor_id}) do
    query =
      from(sale_order in SaleOrder,
        where: sale_order.vendor_id == ^vendor_id,
        preload: [items: [:product], student: []],
        order_by: [desc: sale_order.inserted_at]
      )

    query
    |> Repo.all()
    |> dbg()
  end
end
