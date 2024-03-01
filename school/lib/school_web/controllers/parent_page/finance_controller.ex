defmodule SchoolWeb.ParentPage.FinanceController do
  alias School.Finances
  use SchoolWeb, :controller

  def deposit(conn, %{"student" => student_id, "amount" => amount}) do
    # Move the funds the redirect
    {amount_int, _rem} =
      unless(is_integer(amount), do: Integer.parse(amount), else: {amount, nil})

    result = Finances.deposit_to_sudent_account(student_id, amount_int)

    case result do
      {:ok, _params} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{message: "Successfull"}))

      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        dbg(result)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{message: "Failed to move funds"}))
    end
  end

  def list_recent_transactions(conn, %{"student_id" => student_id}) do
    transactions = Finances.list_student_account_transactions(student_id)

    conn
    |> put_view(SchoolWeb.ParentPage.Views.Transaction)
    |> render(:index, %{transactions: transactions})
  end
end
