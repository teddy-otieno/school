defmodule School.Repo.Migrations.AddMpesaAndBankType do
  use Ecto.Migration

  def up do
    execute("BEGIN TRANSACTION")
    execute("ALTER TYPE public.account_type ADD VALUE IF NOT EXISTS 'mpesa'")
    execute("ALTER TYPE public.account_type ADD VALUE IF NOT EXISTS 'bank'")
    execute("COMMIT")

    execute(
      "INSERT INTO accounts (name, _type, acc_owner, inserted_at, updated_at) VALUES ('Mpesa', 'mpesa', 0, now(), now()), ('Bank', 'bank', 0, now(), now())"
    )
  end

  def down do
  end
end
