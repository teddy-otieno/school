defmodule School.Parent.Parent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parents" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(parent, attrs) do
    parent
    |> cast(attrs, [])
    |> validate_required([])
  end
end
