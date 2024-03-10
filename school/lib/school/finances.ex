defmodule School.Finances do
  import Ecto.Query, warn: false
  alias School.Money.Journal
  alias School.Money.AccountTransactions
  alias School.Repo
  alias Ecto.Multi

  alias School.School.Student
  alias School.Money.Account

  def deposit_to_sudent_account(student_id, amount) when is_number(amount) do
    %Student{id: id} = from(s in Student, where: s.id == ^student_id) |> Repo.one!()

    %Account{id: student_account_id} =
      from(a in Account, where: a._type == :student and a.acc_owner == ^id) |> Repo.one!()

    amount = Money.new(amount * 100, :KES)

    %Account{id: mpesa_account_id} =
      from(a in Account, where: a._type == :mpesa and a.acc_owner == 0) |> Repo.one!()

    Multi.new()
    |> Multi.insert(:from_mpesa, fn _ ->
      %AccountTransactions{}
      |> AccountTransactions.changeset(%{
        "credit" => amount,
        "debit" => Money.new(0),
        "account_id" => mpesa_account_id
      })
    end)
    |> Multi.insert(:to_student_account, fn _ ->
      %AccountTransactions{}
      |> AccountTransactions.changeset(%{
        "credit" => Money.new(0),
        "debit" => amount,
        "account_id" => student_account_id
      })
    end)
    |> Multi.insert(:append_to_journal, fn params ->
      %{
        to_student_account: student_transacton,
        from_mpesa: mpesa_transaction
      } = params

      %Journal{}
      |> Journal.changeset(%{
        "debit_trans" => student_transacton.id,
        "credit_trans" => mpesa_transaction.id,
        "description" => "Student Deposit"
      })
    end)
    |> Repo.transaction()
  end

  def list_student_account_transactions(student_id) do
    query =
      from t in AccountTransactions,
        inner_join: account in Account,
        on: account.id == t.account_id and account._type == :student,
        inner_join: student in Student,
        on: student.id == account.acc_owner,
        where: student.id == ^student_id,
        order_by: [desc: t.inserted_at],
        limit: 20,
        preload: [:debit_entry, :credit_entry]

    Repo.all(query)
  end
end