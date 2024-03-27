defmodule School.Schools do
  @moduledoc """
  The schools context
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias School.Repo

  alias School.Money.Account
  alias School.Accounts.User
  alias School.Parent.Parent
  alias School.School.Vendor
  alias School.School.Class
  alias School.School.Student
  alias School.Vendors.Product
  alias School.SalesProcessing.SaleOrder
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
    |> Multi.insert(:account, fn %{vendor: vendor, user: user} ->
      Account.changeset(
        %Account{
          name: "#{user.first_name} #{user.last_name}",
          _type: :vendor,
          acc_owner: vendor.id
        },
        %{}
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
    # Check for check if profile exists

    %Student{}
    |> Student.changeset(Map.put(attrs, "school_id", id))
    |> Repo.insert()
  end

  def list_students(%School{id: id}) do
    query =
      from s in Student, where: s.school_id == ^id, order_by: [asc: s.id], preload: [:class]

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

  def get_vendor_by_id(id), do: Repo.get!(Vendor, id) |> Repo.preload([:user])

  def get_vendors_most_recent_sales(%Vendor{id: vendor_id}) do
    query =
      from(sale_order in SaleOrder,
        where: sale_order.vendor_id == ^vendor_id,
        order_by: [desc: sale_order.inserted_at],
        limit: 5,
        preload: [:items, :student]
      )

    query
    |> Repo.all()
  end

  def get_vendors_sallable_items(%Vendor{id: vendor_id}) do
    query = from(item in Product, where: item.vendor_id == ^vendor_id)

    query
    |> Repo.all()
  end

  def get_class_by_id(class_id) do
    query =
      from(class in Class, where: class.id == ^class_id, preload: [students: [parent: [:user]]])

    Repo.one(query)
  end

  def get_student_by_id(student_id) do
    Repo.get(Student, student_id)
  end

  @spec update_student(Student.t(), map(), String.t() | nil) ::
          {:ok, Student.t()} | {:error, Ecto.Changeset.t()}
  def update_student(%Student{} = student, attrs, image_path) do
    attrs_with_image =
      unless is_nil(image_path) do
        Map.put(attrs, "profile", image_path)
      else
        attrs
      end

    student
    |> Student.changeset(attrs_with_image)
    |> Repo.update()
  end
end
