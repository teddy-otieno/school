defmodule School.SalesProcessing.CustomerPayment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_customer_payments" do
    timestamps(type: :utc_datetime)
  end
end
