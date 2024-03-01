defmodule School.Schools do
  @moduledoc """
  The schools context
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi

  alias School.Accounts.User
  alias School.Repo
  alias School.Parent.Parent
  alias School.School.Vendor
  alias School.School.Class
  alias School.School.Student
  alias School.School

  def setup_school(%User{} = user, params) do
    params_with_account_manager = Map.put(params, "account_manager_id", user.id)

    %School{}
    |> School.changeset(params_with_account_manager)
    |> Repo.insert()
  end

  def find_school_setup_by_user(%User{} = user) do
    Repo.get_by(School, account_manager_id: user.id)
  end

  def create_vendor(school = %School{}, params) do
    params_with_added_user_type =
      Map.merge(params, %{
        "is_parent" => false,
        "is_admin" => false,
        "is_vendor" => true,
        "is_student" => false,
        "is_school" => false
      })

    Multi.new()
    |> Multi.insert(:user, User.registration_changeset(%User{}, params_with_added_user_type))
    |> Multi.insert(:vendor, fn %{user: user = %User{}} ->
      Vendor.changeset(
        %Vendor{},
        Map.merge(params, %{"user_id" => user.id, "school_id" => school.id})
      )
    end)
    |> Repo.transaction()
  end

  def fetch_all_vendors(school = %School{}) do
    query =
      from v in Vendor,
        where: v.school_id == ^school.id and not is_nil(v.user_id),
        preload: [:user],
        select: v

    Repo.all(query)
  end

  def fetch_school_record_for_user(user = %User{}) do
    query = from s in School, where: s.account_manager_id == ^user.id, select: s

    Repo.one!(query)
    |> dbg
  end

  def create_new_class(params, %School{id: id}) do
    %Class{}
    |> Class.changeset(Map.put(params, "school_id", id))
    |> Repo.insert()
  end

  def list_classes_for_user(%School{id: id}) do
    query = from c in Class, where: c.school_id == ^id

    query
    |> Repo.all()
  end

  def create_student(attrs, %School{id: id}) do
    %Student{}
    |> Student.changeset(Map.put(attrs, "school_id", id))
    |> Repo.insert()
  end

  def list_students(%School{id: id}) do
    query = from s in Student, where: s.school_id == ^id, preload: [:class]

    query
    |> Repo.all()
  end

  def list_parents_in_school(%School{id: id}) do
    query =
      from p in Parent,
        inner_join: student in Student,
        on: student.parent_id == p.id,
        where: student.school_id == ^id,
        select: %{parent: p, student: student},
        preload: [:user]

    query |> Repo.all()
  end
end
