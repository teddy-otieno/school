defmodule School.Parents do
  import Ecto.Query, warn: false
  alias School.Repo
  alias Ecto.Multi

  alias School.Accounts.User
  alias School.Parent.Parent
  alias School.School.Student
  alias School.Money.Account
  alias School.Money.AccountTransactions
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

  def fetch_student_account_and_balance(%Student{id: id} = student) do
    query =
      from a in Account,
        join: trans in AccountTransactions,
        on: a.id == trans.account_id,
        where: a.acc_owner == ^id and a._type == :student,
        select: fragment("sum((?).amount) - sum((?).amount)", trans.debit, trans.credit)

    result =
      query
      |> Repo.one()

    %{student: student, balance: if(is_nil(result), do: 0, else: result)}
  end

  def assign_to_parent(%Parent{id: parent_id}, student_id) do
    query = from s in Student, where: s.id == ^student_id

    student =
      Repo.get(query, student_id)

    # Setup the accounts
    Multi.new()
    |> Multi.update(:student, Student.changeset(student, %{"parent_id" => parent_id}))
    |> Multi.insert(:account, fn %{student: %Student{} = student} ->
      %Account{}
      |> Account.changeset(%{
        "name" => student.first_name <> " " <> student.last_name,
        "_type" => "student",
        "acc_owner" => student.id
      })
    end)
    |> Repo.transaction()
  end

  def fetch_student_and_transaction_history(id) do
    query =
      from a in Account,
        join: trans in AccountTransactions,
        on: a.id == trans.account_id,
        join: student in Student,
        on: student.id == a.acc_owner,
        where: student.id == ^id and a._type == :student,
        select: %{debit: trans.debit, credit: trans.credit, created_at: trans.created_at}

    Repo.all(query)
  end
end
