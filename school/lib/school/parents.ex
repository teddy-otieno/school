defmodule School.Parents do
  import Ecto.Query, warn: false
  require Logger
  alias School.Money.Journal
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
    |> Multi.insert(:account, fn %{parent: parent, user: user} ->
      Account.changeset(
        %Account{
          name: "#{user.first_name} #{user.last_name}",
          _type: :parent,
          acc_owner: parent.id
        },
        %{}
      )
    end)
    |> Repo.transaction()
  end

  def get_parent_from_user(%User{is_parent: true, id: id}) do
    query = from p in Parent, where: p.user_id == ^id, preload: [:user]

    query
    |> Repo.one!()
  end

  def list_students_from_parent(%Parent{id: id}) do
    query = from s in Student, where: s.parent_id == ^id, preload: [:class]

    query
    |> Repo.all()
  end

  def list_students_from_parent(nil) do
    Logger.debug("parent was not provided")
    []
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
  end

  def fetch_student_account_and_balance(%Student{id: id} = student) do
    fetch_account_status =
      from(trans in AccountTransactions,
        where: trans.account_id == parent_as(:account).id,
        select:
          fragment(
            "CASE WHEN (sum((?).amount - (?).amount)) > 50000 THEN 'OK' ELSE 'LOW' END",
            trans.debit,
            trans.credit
          )
      )

    query =
      from a in Account,
        as: :account,
        join: trans in AccountTransactions,
        on: a.id == trans.account_id,
        where: a.acc_owner == ^id and a._type == :student,
        group_by: [a.id],
        select:
          {fragment("COALESCE(SUM((?).amount) - SUM((?).amount))", trans.debit, trans.credit),
           subquery(fetch_account_status)}

    case Repo.one(query) do
      {balance, status} ->
        %{student: student, balance: if(is_nil(balance), do: 0, else: balance), status: status}

      _ ->
        %{student: student, balance: 0, status: "LOW"}
    end
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

  @type informatics() :: %{
          total_balance: integer(),
          learner_count: integer(),
          student_account_balances: list(%{student: Student.t(), balance: integer()})
        }

  @doc """
    Return the total balance,
    the number of learners
    status of the students accounts, running low, or good.
  """
  @spec get_parent_informatics(Parent.t()) :: informatics()
  def get_parent_informatics(%Parent{id: parent_id}) do
    # return total balance for all wallets

    total_balance =
      from(
        trans in AccountTransactions,
        inner_join: account in Account,
        on: account.id == trans.account_id and account._type == :student,
        inner_join: student in Student,
        on: student.id == account.acc_owner,
        where: student.parent_id == ^parent_id,
        select: fragment("sum((?).amount - (?).amount)", trans.debit, trans.credit)
      )
      |> Repo.one()
      |> (fn x -> if(is_nil(x), do: 0, else: x) end).()

    number_of_learners =
      from(student in Student, where: student.parent_id == ^parent_id, select: count(student.id))
      |> Repo.one()

    fetch_account_balance_subquery =
      from(trans in AccountTransactions,
        where: trans.account_id == parent_as(:account).id,
        select: fragment("sum((?).amount - (?).amount)", trans.debit, trans.credit)
      )

    fetch_account_status =
      from(trans in AccountTransactions,
        where: trans.account_id == parent_as(:account).id,
        select:
          fragment(
            "CASE WHEN (sum((?).amount - (?).amount)) > 50000 THEN 'OK' ELSE 'LOW' END",
            trans.debit,
            trans.credit
          )
      )

    # FIXME: (teddy) Limit this to the target parent
    status_of_each_account =
      from(account in Account,
        as: :account,
        inner_join: student in Student,
        on: student.id == account.acc_owner and account._type == :student,
        where: student.parent_id == ^parent_id,
        select: %{
          student: student,
          balance: fragment("COALESCE(?, 0)", subquery(fetch_account_balance_subquery)),
          status: subquery(fetch_account_status)
        }
      )
      |> Repo.all()

    %{
      total_balance: total_balance,
      learner_count: number_of_learners,
      student_account_balances: status_of_each_account
    }
  end

  @type profile_data() :: %{transaction_history: AccountTransactions.t(), parent: Parent.t()}

  @spec load_parent_profile_and_transactions(Parent.t()) :: profile_data()
  def load_parent_profile_and_transactions(%Parent{id: parent_id} = parent) do
    # TODO: (teddyy) Add pagination
    # NOTE: (Teddy) We're remove duplicated transactions
    transaction_history =
      from(trans in AccountTransactions,
        inner_join: account in Account,
        on:
          trans.account_id == account.id and account._type == :parent and
            account.acc_owner == ^parent_id,
        order_by: [desc: trans.inserted_at, desc: trans.id],
        preload: [:debit_entry, :credit_entry]
      )
      |> Repo.all()

    %{
      transaction_history: transaction_history,
      parent: parent |> Repo.preload(:user)
    }
  end
end
