defmodule SchoolWeb.ParentPage.Views.Informatics do

  @spec show(%{informatics: School.Parents.informatics()}) :: any()
  def show(%{informatics: informatics}) do
    %{data: data(informatics)}
  end

  @spec data(School.Parents.informatics()) :: any()
  def data(informatics) do
    %{
      overall_balance: informatics.total_balance |> Money.new() |> Money.to_string(),
      learner_count: informatics.learner_count,
      student_balances:
        informatics.student_account_balances
        |> Enum.map(fn x ->
          %{
            id: x.student.id,
            balance: x.balance |> Money.new() |> Money.to_string(),
            name: "#{x.student.first_name} #{x.student.last_name}",
            status: x.status
          }
        end)
    }
  end
end
