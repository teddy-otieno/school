defmodule School.Repo.Migrations.AlterVendorTableTieToSchool do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      # FIXME: (teddy) remove the default after executing the migration
      add(:school_id, references(:school, on_delete: :delete_all), null: false, default: 2)
    end
  end
end
