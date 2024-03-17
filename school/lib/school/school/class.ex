defmodule School.School.Class do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.School.Student
  alias School.School

  schema "classes" do
    field :type, Ecto.Enum, values: [:form, :class]
    field :label, :string
    belongs_to :school, School

    has_many :students, Student, foreign_key: :class_id, references: :id
    timestamps(type: :utc_datetime)
  end

  def changeset(class, attrs) do
    class
    |> cast(attrs, [:type, :label, :school_id])
    |> validate_required([:type, :label, :school_id])
  end
end
