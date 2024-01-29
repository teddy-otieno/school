defmodule School.School.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [])
    |> validate_required([])
  end
end
