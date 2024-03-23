defmodule School.Repo.Migrations.AddProfileToStudents do
  use Ecto.Migration

  def change do
    alter table(:students) do
      add :profile, :string, size: 5024
    end
  end
end
