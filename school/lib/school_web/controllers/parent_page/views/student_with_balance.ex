defmodule SchoolWeb.ParentPage.Views.StudentWithBalance do
  def index(%{students: students}) do
    %{data: for(%{student: student, balance: balance} <- students, do: data(student, balance))}
  end

  def show(%{student: %{student: student, balance: balance}}) do
    %{data: data(student, balance)}
  end

  def data(student, balance) do
    money_balance = Money.new(balance)

    %{
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      balance: Money.to_string(money_balance)
    }
  end
end
