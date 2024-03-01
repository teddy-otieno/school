defmodule School.Money.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Money.Account

  schema "accounts" do
    field :name, :string
    field :_type, Ecto.Enum, values: [:vendor, :student, :parent, :school, :admin, :mpesa, :bank]

    field :acc_owner, :integer
    timestamps(type: :utc_datetime)
  end

  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:name, :_type, :acc_owner])
    |> validate_required([:name, :_type, :acc_owner])
    |> unique_constraint([:_type, :acc_owner], name: :accounts_type_entity_unique)
  end
end
