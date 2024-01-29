defmodule School.Repo.Migrations.CreateSchool do
  use Ecto.Migration

  def change do
    create table(:school) do
      add :name, :string, null: false, size: 1024
      add :about, :string, null: true, size: 1024
      add :address, :string, null: false, size: 512
      add :is_deleted, :boolean, default: false

      add :account_manager_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:school, [:name])
  end
end
