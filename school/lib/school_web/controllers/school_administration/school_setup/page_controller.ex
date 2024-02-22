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

  def classes(conn, _params) do
    school_classes =
      conn.assigns[:current_user]
      |> Schools.fetch_school_record_for_user()
      |> Schools.list_classes_for_user()

    conn
    |> put_layout(html: :layout)
    |> render(:classes, classes: school_classes)
  end

  def create_class(conn, %{"create_class" => _} = params) do
    token = Plug.CSRFProtection.get_csrf_token()

    current_user_school =
      conn.assigns[:current_user]
      |> Schools.fetch_school_record_for_user()

    result =
      params
      |> Schools.create_new_class(current_user_school)

    with {:ok, _new_class} <- result do
      conn
      |> redirect(to: ~p"/school/classes")
    else
      error ->
        dbg(error)
        # FIXME: (teddy) Please add an error handler for this
        conn
        |> put_layout(html: :layout)
        |> render(:create_class, token: token)
    end
  end

  def create_class(conn, _params) do
    token = Plug.CSRFProtection.get_csrf_token()

    conn
    |> put_layout(html: :layout)
    |> render(:create_class, token: token)
  end
end
