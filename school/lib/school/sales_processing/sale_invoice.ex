defmodule School.SalesProcessing.SaleInvoice do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.SalesProcessing.SaleInvoice

  schema "sales_invoice" do
    timestamps(type: :utc_datetime)
  end

  def changeset(%SaleInvoice{} = invoice, attrs) do
  end
end
