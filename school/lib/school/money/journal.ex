defmodule School.Money.Journal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journal" do
    field :description
  end

  def changeset(entry, attrs) do
    entry
    |> cast([:description, :debit_trans, :credit_trans])
    |> validate_required([:debit_trans, :credit_trans])
  end
end
