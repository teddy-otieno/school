defmodule School.Repo.Migrations.ChangeTimestampDatatype do
  use Ecto.Migration

  def change do
    alter(table(:sales_orders)) do
      modify(:timestamp, :bigint)
    end
  end
end
