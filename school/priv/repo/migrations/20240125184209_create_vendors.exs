defmodule School.Repo.Migrations.CreateVendors do
  use Ecto.Migration

  def change do
    create table(:vendors) do
      add :vendor_name, :string, size: 512
      add :till_number, :string, size: 512

      add :user_id, references(:users, on_delete: :delete_all), null: true
      timestamps(type: :utc_datetime)
    end

    # Add  a vendor account
    alter table(:users) do
      add :is_vendor, :boolean, null: false, default: false
    end
  end
end
