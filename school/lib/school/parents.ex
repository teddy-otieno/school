defmodule School.Parents do
  import Ecto.Query, warn: false
  alias School.Repo
  alias Ecto.Multi

  alias School.Accounts.User
  alias School.Parent.Parent
  alias School.School.Student
  alias School.School

  def create_parent_account(params) do
    Multi.new()
    |> Multi.insert(
      :user,
      User.registration_changeset(
        %User{},
        Map.merge(params, %{
          "is_school" => false,
          "is_vendor" => false,
          "is_parent" => true,
          "is_admin" => false
        })
      )
    )
    |> Multi.insert(:parent, fn %{user: user} ->
      Parent.changeset(%Parent{}, %{"user_id" => user.id})
    end)
    |> Repo.transaction()
  end

  def get_parent_from_user(%User{is_parent: true, id: id}) do
    query = from p in Parent, where: p.id == ^id, preload: [:user]

    query
    |> Repo.one()
  end

  def list_students_from_parent(%Parent{id: id}) do
    query = from s in Student, where: s.parent_id == ^id, preload: [:class]

    query
    |> Repo.all()
  end

  def find_child_in_schools(school_name, child_name) do
    query =
      from s in School,
        left_join: student in Student,
        on: student.school_id == s.id,
        where:
          ilike(s.name, ^"#{school_name}%") and
            ilike(
              fragment("concat(?, ' '  ,?)", student.first_name, student.last_name),
              ^"#{child_name}%"
            ),
        select: {s, student}

    query
    |> Repo.all()
    |> dbg
  end

  def assign_to_parent(%Parent{id: parent_id}, student_id) do
    query = from s in Student, where: s.id == ^student_id

    student =
      Repo.get(query, student_id)
      |> dbg
      |> Student.changeset(%{"parent_id" => parent_id})
      |> Repo.update(returning: true)
  end
end
