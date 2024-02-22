defmodule School.Repo.Migrations.CreateSchoolClasses do
  use Ecto.Migration

  def change do
    execute("CREATE TYPE class_type as ENUM ('form', 'class')")

    create table(:classes) do
      add :type, :class_type, null: false
      add :label, :string, size: 512, null: false

      add :school_id, references(:school, on_delete: :delete_all, on_update: :update_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:classes, [:type, :label],
             name: "classes_unique_type_and_label",
             comment: "Unique index on type and label"
           )

    alter table(:students) do
      add :class_id, references(:classes, on_delete: :delete_all, on_update: :update_all),
        null: false
    end
  end

  def down do
    drop table(:classes)
    execute("DROP TYPE class_type")
  end
end
