defmodule SchoolWeb.LoginPage.PageController do
  use SchoolWeb, :controller
  alias SchoolWeb.UserAuth
  alias School.Accounts

  alias School.Accounts.User

  def home(conn, _params) do
    token = Plug.CSRFProtection.get_csrf_token();
    conn
    |> render(:home, layout: false, token: token)
  end


  def login(conn, %{"email" => email_or_phone, "password" => password} = params) do

    if user = Accounts.get_user_by_email_and_password(email_or_phone, password) do
      conn
      |>put_session(:user_return_to, School.Utils.redirect_route_based_on_user_type(user))
      |> UserAuth.log_in_user(user, params)
    end
      conn
      |> put_flash(:error, "Invalid email or password")
      # |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/login")
  end
end
