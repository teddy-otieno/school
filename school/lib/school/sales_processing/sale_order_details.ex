defmodule School.SalesProcessing.SaleOrderDetails do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.SalesProcessing.SaleOrder
  alias School.Vendors.Product
  alias School.SalesProcessing.SaleOrderDetails

  schema "sales_order_details" do
    field :purchase_price, Money.Ecto.Composite.Type
    field :memo, :string

    belongs_to :product, Product, foreign_key: :product_id
    belongs_to :sales_order, SaleOrder, foreign_key: :sales_order_id

    timestamps(type: :utc_datetime)
  end

  def changeset(%SaleOrderDetails{} = detail, attrs) do
    detail
    |> cast(attrs, [:purchase_price, :memo, :product_id, :sales_order_id])
    |> validate_required([:purchase_price, :product_id, :sales_order_id])
  end
end
