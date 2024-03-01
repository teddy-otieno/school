defmodule School.Money.AccountTransactions do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Money.Journal
  alias School.Money.Account

  schema("account_transactions") do
    field :debit, Money.Ecto.Composite.Type
    field :credit, Money.Ecto.Composite.Type

    field :comment, :string
    belongs_to :owner, Account, foreign_key: :account_id
    has_one(:debit_entry, Journal, foreign_key: :debit_trans)
    has_one(:credit_entry, Journal, foreign_key: :credit_trans)
    timestamps(type: :utc_datetime)
  end

  def changeset(account_transaction, attrs) do
    account_transaction
    |> cast(attrs, [:debit, :credit, :comment, :account_id])
    |> validate_required([:debit, :credit, :account_id])
  end
end
