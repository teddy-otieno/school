defmodule SchoolWeb.ParentPage.Views.StudentWithBalance do
  def index(%{students: students}) do
    %{
      data:
        for(
          %{student: student, balance: balance, status: status} <- students,
          do: data(student, balance, status)
        )
    } |> dbg
  end

  def show(%{student: %{student: student, balance: balance, status: status}}) do
    %{data: data(student, balance, status)}
  end

  def data(student, balance, status) do
    money_balance = Money.new(balance)

    %{
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      balance: Money.to_string(money_balance),
      status: status
    }
  end
end
