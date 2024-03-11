defmodule School.Repo.Migrations.AddTimestampStudentIdUniqueConstraint do
  use Ecto.Migration

  def change do
    drop_if_exists unique_index(:sales_orders, :timestamp)
    create unique_index(:sales_orders, [:timestamp, :student_id])
  end
end
