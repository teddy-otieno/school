defmodule School.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :first_name, :string, null: false, size: 512
      add :last_name, :string, null: false, size: 512
      add :is_deleted, :boolean, default: false

      add :school_id, references(:school, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end
  end
end
