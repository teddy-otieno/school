defmodule School.Parent.Parent do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Accounts.User

  @type t() :: %School.Parent.Parent{}

  schema "parents" do
    belongs_to :user, User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(parent, attrs) do
    parent
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
