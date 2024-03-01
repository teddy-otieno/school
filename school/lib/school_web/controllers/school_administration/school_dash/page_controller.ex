defmodule SchoolWeb.SchoolAdministration.SchoolDash.PageController do
  use SchoolWeb, :controller

  alias School.Schools
  alias School.Accounts

  def home(conn, _params) do
    conn
    |> put_layout(html: :layout)
    |> render(:home)
  end

  def vendors(conn, _params) do
    vendors =
      conn
      |> get_school_info_of_current_user()
      |> Schools.fetch_all_vendors()

    dbg(vendors)

    conn
    |> put_layout(html: :layout)
    |> render(:vendors, vendor_list: vendors)
  end

  defp get_school_info_of_current_user(conn) do
    conn.assigns[:current_user]
    |> Schools.fetch_school_record_for_user()
  end

  def create_vendor(
        conn,
        %{"vendor_name" => _vendor_name, "till_number" => _till_number, "submit" => _submit_value} =
          params
      ) do
    # Add the vendor to the database and setup the user accounts

    # Create the user then vendor
    result =
      Schools.fetch_school_record_for_user(conn.assigns[:current_user])
      |> Schools.create_vendor(params)

    case result do
      {:ok, %{user: _user, vendor: _vendor}} ->
        conn |> redirect(to: ~p"/school/vendors")

      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        # TODO: (teddy) Figure out what to do with this condition
        conn
    end
  end

  def create_vendor(conn, _params) do
    token = Plug.CSRFProtection.get_csrf_token()

    conn
    |> put_layout(html: :layout)
    |> render(:add_vendor, token: token, type: "VENDOR")
  end

  def students(conn, _params) do
    students =
      conn.assigns[:current_user]
      |> Schools.fetch_school_record_for_user()
      |> Schools.list_students()

    conn
    |> put_layout(html: :layout)
    |> render(:students, students: students)
  end

  def create_student(conn, %{"create_student" => _} = params) do
    school =
      conn.assigns[:current_user]
      |> Schools.fetch_school_record_for_user()

    with {:ok, student} <- Schools.create_student(params, school) do
      dbg(student)

      conn
      |> redirect(to: ~p"/school/students")
    else
      {:error, changeset} ->
        dbg(changeset)
        token = Plug.CSRFProtection.get_csrf_token()

        classes_or_forms =
          conn.assigns[:current_user]
          |> Schools.fetch_school_record_for_user()
          |> Schools.list_classes_for_user()

        conn
        |> put_layout(html: :layout)
        |> render(:create_student, token: token, classes: classes_or_forms)
    end
  end

  def create_student(conn, _params) do
    token = Plug.CSRFProtection.get_csrf_token()

    classes_or_forms =
      conn.assigns[:current_user]
      |> Schools.fetch_school_record_for_user()
      |> Schools.list_classes_for_user()

    conn
    |> put_layout(html: :layout)
    |> render(:create_student, token: token, classes: classes_or_forms)
  end

  def index_parents(conn, _params) do
    parents =
      conn.assigns[:current_user]
      |> Schools.fetch_school_record_for_user()
      |> Schools.list_parents_in_school()
      |> dbg

    conn
    |> put_layout(html: :layout)
    |> render(:index_parents, parents: parents)
  end
end
