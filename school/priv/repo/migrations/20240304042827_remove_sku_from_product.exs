defmodule School.Repo.Migrations.RemoveSkuFromProduct do
  use Ecto.Migration

  def up do
    drop unique_index(:product_items, [:product_name, :sku])

    alter table(:product_items) do
      remove :sku
    end

    create unique_index(:product_items, [:product_name])
  end

  def change do
  end
end
