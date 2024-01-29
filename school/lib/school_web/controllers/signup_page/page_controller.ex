defmodule SchoolWeb.SignupPage.PageController do
  use SchoolWeb, :controller

  alias SchoolWeb.UserAuth
  alias School.Accounts

  def home(conn, params) do
    token = Plug.CSRFProtection.get_csrf_token()
    type = "PARENT"

    type = if temp = Map.get(params, "type") do
      temp
    else
      "SCHOOL"
    end

    if type in ["SCHOOL", "ADMIN", "PARENT", "VENDOR"] do
      render(conn, :signup, layout: false, token: token, type: type)
    else
      # TODO: (teddy) Render an error page
      conn
      |> send_resp(404, "")
    end
  end

  defp redirect_based_on_user_type(conn, type) do
    path = case type do
      "SCHOOL" -> ~p"/school/setup"
      "PARENT" -> ~p"/parent"
      "ADMIN" -> ~p"/admin"
    end

    put_session conn, :user_return_to, path
  end

  # Note: (teddy) We're signing up the users first
  defp signup_user(conn, first_name, last_name, email, phone_number, password, type) do
    with {:ok, user} <-
           Accounts.register_user(%{
             first_name: first_name,
             last_name: last_name,
             email: email,
             phone_number: phone_number,
             password: password,
             is_school: type === "SCHOOL",
             is_parent: type === "PARENT",
             is_admin: type === "ADMIN",
             is_vendor: type === "VENDOR"
           }) do
      conn
      |> redirect_based_on_user_type(type)
      |> UserAuth.log_in_user(user, %{})
    else
      {:error, changeset} ->
        conn
        |> render(:signup_failed, layout: false)
    end
  end

  def handle_signup(conn, params) do
    %{
      "first_name" => first_name,
      "last_name" => last_name,
      "email" => email,
      "phone_number" => phone_number,
      "password" => password,
      "confirm_password" => confirm_password,
      "type" => type
    } = params

    if password !== confirm_password do
      conn
      |> render(:signup_failed, layout: false)
    else
      signup_user(conn, first_name, last_name, email, phone_number, password, type)
    end
  end
end
