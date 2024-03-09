defmodule School.Repo.Migrations.CreateSalesProcessingTables do
  use Ecto.Migration

  @doc """
  The transaction id used across the sales process will be the sales_order information
  """
  def change do
    create table(:sales_orders) do
      add :student_id, references(:students), null: false
      add :vendor_id, references(:vendors), null: false
      add :memo, :string, size: 5012

      timestamps(type: :utc_datetime)
    end

    create table(:sales_order_details) do
      add :product_id, references(:product_items), null: false
      add :purchase_price, :money_with_currency, null: false
      add :memo, :string, size: 5012

      add :sales_order_id, references(:sales_orders), null: false
      timestamps(type: :utc_datetime)
    end

    create table(:sales_invoice) do
      # Use this to fetch the items we'll require for the sales order
      add :sales_order_id, references(:sales_orders), null: false
      timestamps(type: :utc_datetime)
    end

    create table(:sales_customer_payments) do
      add :amount, :money_with_currency, null: false
      # NOTE: (teddy) Most like mpesa reference number
      add :ref_number, :string, size: 1024, null: false
      add :payment_time, :utc_datetime, null: false
      add :invoice_id, references(:sales_invoice), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:sales_invoice, :sales_order_id)
  end
end
