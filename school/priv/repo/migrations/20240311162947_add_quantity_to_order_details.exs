defmodule School.Repo.Migrations.AddQuantityToOrderDetails do
  use Ecto.Migration

  def change do
    alter table(:sales_order_details) do
      add :quantity, :integer, null: false, default: 0
    end
  end
end
