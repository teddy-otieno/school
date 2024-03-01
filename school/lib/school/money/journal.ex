defmodule School.Money.Journal do
  alias School.Money.AccountTransactions
  use Ecto.Schema
  import Ecto.Changeset

  schema "journal" do
    field :description, :string

    belongs_to :debit, AccountTransactions, foreign_key: :debit_trans
    belongs_to :credit, AccountTransactions, foreign_key: :credit_trans

    timestamps(type: :utc_datetime)
  end

  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:description, :debit_trans, :credit_trans])
    |> validate_required([:debit_trans, :credit_trans])
  end
end
