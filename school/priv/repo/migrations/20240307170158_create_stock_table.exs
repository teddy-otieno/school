defmodule School.Repo.Migrations.CreateStockTable do
  use Ecto.Migration

  def up do
    drop_if_exists index(:product_items, [:product_name])
    create_if_not_exists unique_index(:product_items, [:product_name, :vendor_id])

    create table(:stock_movement) do
      add :product_id, references(:product_items), null: false
      add :quantity, :integer, null: false
      add :comment, :text

      timestamps(type: :utc_datetime)
    end
  end

  def change do
  end

  def down do
    drop_if_exists unique_index(:product_items, [:product_name, :vendor_id])
    drop table(:stock_movement)
  end
end
