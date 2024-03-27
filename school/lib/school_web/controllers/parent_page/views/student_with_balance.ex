defmodule SchoolWeb.ParentPage.Views.StudentWithBalance do
  alias School.School.Student

  def index(%{students: students}) do
    %{
      data:
        for(
          %{student: student, balance: balance, status: status} <- students,
          do: data(student, balance, status)
        )
    }
  end

  def show(%{student: %{student: student, balance: balance, status: status}}) do
    %{data: data(student, balance, status)}
  end

  @spec data(Student.t(), any(), String.t()) :: Student.student_data()
  def data(student, balance, status) do
    money_balance = Money.new(balance)
    Student.to_data(student, money_balance, status)
  end
end
