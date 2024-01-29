defmodule School.Repo.Migrations.ChangeParentIdFromSchoolToParent do
  use Ecto.Migration

  def change do
    alter table(:students) do
      remove :parent_id
    end

    alter table(:students) do
      add :parent_id, references(:parents, on_delete: :delete_all)
    end
  end
end
