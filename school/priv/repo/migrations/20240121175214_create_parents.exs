defmodule School.Repo.Migrations.CreateParents do
  use Ecto.Migration

  def change do
    create table(:parents) do
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    alter table(:students) do
      add :parent_id, references(:school, on_delete: :delete_all)
    end
  end
end
