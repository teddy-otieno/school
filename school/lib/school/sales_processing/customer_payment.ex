defmodule School.SalesProcessing.CustomerPayment do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.SalesProcessing.SaleInvoice
  alias School.SalesProcessing.CustomerPayment

  schema "sales_customer_payments" do
    field :amount, Money.Ecto.Composite.Type
    field :ref_number, :string
    field :payment_time, :utc_datetime

    timestamps(type: :utc_datetime)
    belongs_to :invoice, SaleInvoice, foreign_key: :invoice_id
  end

  def changeset(%CustomerPayment{} = payment, attrs) do
    payment
    |> cast(attrs, [:amount, :ref_number, :payment_time, :invoice_id])
    |> validate_required([:amount, :ref_number, :payment_time, :invoice_id])
  end
end
