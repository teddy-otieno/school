defmodule School.SalesProcessing.SaleInvoice do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.SalesProcessing.SaleInvoice
  alias School.SalesProcessing.SaleOrder

  schema "sales_invoice" do
    timestamps(type: :utc_datetime)

    belongs_to :sales_order, SaleOrder, foreign_key: :sales_order_id
  end

  def changeset(%SaleInvoice{} = invoice, attrs) do
    invoice
    |> cast(attrs, [:sales_order_id])
    |> validate_required([:sales_order_id])
  end
end
