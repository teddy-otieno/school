defmodule SchoolWeb.SchoolAdministration.SchoolDash.PageController do
  use SchoolWeb, :controller

  alias School.Schools
  alias School.Accounts


  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
  end

  def vendors(conn, _params) do
    conn
    |> put_layout(html: :layout)
    |> render(:vendors)
  end


  def create_vendor(conn, %{"vendor_name" => vendor_name, "till_number" => till_number, "submit" => submit_value} = params) do
    # Add the vendor to the database and setup the user accounts

    # Create the user then vendor
    case Schools.create_vendor(params) do
      
      {:ok, %{user: user, vendor: vendor}} ->
        conn |> redirect(~p"/school/vendors")
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
