defmodule SchoolWeb.SchoolAdministration.SchoolDash.PageController do
  use SchoolWeb, :controller

  alias School.Schools
  alias School.Accounts

  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
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

      {:error, failed_operation, failed_value, changes_so_far} ->
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
end
