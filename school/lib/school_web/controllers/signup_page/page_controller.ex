defmodule SchoolWeb.SignupPage.PageController do
  use SchoolWeb, :controller

  alias SchoolWeb.UserAuth
  alias School.Accounts

  def home(conn, _params) do
    token = Plug.CSRFProtection.get_csrf_token()

    render(conn, :signup, layout: false, token: token)
  end

  # Note: (teddy) We're signing up the users first
  defp signup_user(conn, first_name, last_name, email, phone_number, password) do
    with {:ok, user} <-
           Accounts.register_user(%{
             first_name: first_name,
             last_name: last_name,
             email: email,
             phone_number: phone_number,
             password: password
           }) do
      IO.inspect(user)

      conn
      |> UserAuth.log_in_user(user, %{})
    else
      {:error, changeset} ->
        IO.inspect(changeset)

        conn
        |> render(:signup_failed, layout: false)
    end
  end

  def handle_signup(conn, %{
        "first_name" => first_name,
        "last_name" => last_name,
        "email" => email,
        "phone_number" => phone_number,
        "password" => password,
        "confirm_password" => confirm_password
      }) do
    if password !== confirm_password do
      conn
      |> render(:signup_failed, layout: false)
    else
      signup_user(conn, first_name, last_name, email, phone_number, password)
    end
  end
end
