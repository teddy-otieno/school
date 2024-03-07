defmodule School.Repo.Migrations.AddProductImage do
  use Ecto.Migration

  def change do
    alter table(:product_items) do
      add :image, :string, size: 5012
    end
  end
end
