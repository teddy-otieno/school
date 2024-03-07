defmodule School.Repo.Migrations.CreateProductTable do
  use Ecto.Migration

  def change do
    create table(:product_items) do
      add :product_name, :string, size: 1024, null: false
      add :description, :string, size: 1024
      add :vendor_id, references(:vendors, on_delete: :delete_all), null: false
      add :sku, :string, size: 1024, null: false
      add :price, :money_with_currency, null: false
      add :purchase_date, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:product_items, [:product_name, :sku])
  end
end
