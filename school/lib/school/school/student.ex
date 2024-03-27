defmodule School.School.Student do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Parent.Parent
  alias School.School.Class
  alias School.School.Student

  @type t() :: %Student{}

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

  @type student_data() :: %{
           id: integer(),
           first_name: String.t(),
           last_name: String.t(),
           balance: String.t(),
           status: String.t(),
           image: String.t()
         }

  @doc """
    render representation of the student struct
  """
  @spec to_data(Student.t(), Money.t(), String.t()) :: student_data()
  def to_data(%Student{} = student, balance, status) do
    %{
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      balance: Money.to_string(balance),
      status: status,
      image:
        unless(is_nil(student.profile),
          do: "media/" <> Path.relative_to(student.profile, "./output"),
          else: nil
        )
    }
  end
end
