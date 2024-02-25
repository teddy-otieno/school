defmodule School.Repo.Migrations.CreateAccountingAndMoney do
  use Ecto.Migration

  def change do
    execute """
    CREATE TYPE public.money_with_currency AS (amount integer, currency VARCHAR(3))
    """

    execute(
      "CREATE TYPE public.account_type AS ENUM('vendor', 'student', 'parent', 'school', 'admin')"
    )

    create table(:accounts) do
      add :name, :string, size: 1024, null: false
      add :_type, :account_type, null: false
      add :acc_owner, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:accounts, [:_type, :acc_owner],
             name: "accounts_type_entity_unique",
             comment:
               "Ensure the accounts are unique. Since we'll have multiple accounts for each type"
           )

    create table(:account_transactions) do
      add(:debit, :money_with_currency, null: false)
      add :credit, :money_with_currency, null: false
      add :comment, :string, size: 1024

      add :account_id, references(:accounts, on_delete: :delete_all, on_update: :update_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create table(:journal) do
      add :debit_trans, references(:account_transactions), null: false
      add :credit_trans, references(:account_transactions), null: false
      add :description, :string, size: 1024

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    execute """
    DROP TYPE public.money_with_currency;

    """

    execute("DROP TYPE public.account_type;")
  end
end
