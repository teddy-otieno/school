defmodule School.School.Student do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Parent.Parent
  alias School.School.Class

  @type t() :: %School.School.Student{}

  alias School.School


  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :profile, :string

    belongs_to :school, School
    belongs_to :parent, Parent
    belongs_to :class, Class

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:first_name, :last_name, :school_id, :parent_id, :class_id, :profile])
    |> validate_required([:first_name, :last_name, :school_id, :class_id])
  end
end
