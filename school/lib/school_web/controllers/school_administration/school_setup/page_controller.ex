defmodule SchoolWeb.SchoolAdministration.SchoolSetup.PageController do
  use SchoolWeb, :controller

  alias School.Schools

  def home(conn, _params) do
    token = Plug.CSRFProtection.get_csrf_token()

    # NOTE: (teddy) check if user already has school setup and redirect
    existing_school_setup = Schools.find_school_setup_by_user(conn.assigns[:current_user])

    if existing_school_setup do
      conn
      |> redirect(to: ~p"/school/dash")
    else
      conn
      |> render(:home, layout: false, token: token, message: nil)
    end
  end

  def setup(conn, %{"name" => _name, "address" => _address, "about" => _about} = params) do
    Schools.setup_school(conn.assigns[:current_user], params)

    conn
    |> redirect(to: ~p"/school/dash")
  end

  def setup(conn, _params) do
    token = Plug.CSRFProtection.get_csrf_token()
    message = "Invalid operation. Please try again"

    conn
    |> render(:home, layout: false, token: token, message: message)
  end
end
