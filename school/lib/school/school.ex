defmodule School.School do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Accounts.User

  schema "school" do
    field :name, :string
    field :about, :string
    field :address, :string

    belongs_to :user, User, foreign_key: :account_manager_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :about, :address, :account_manager_id])
    |> validate_required([:name, :about, :address, :account_manager_id])
  end
end
