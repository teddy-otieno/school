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
        %{"vendor_name" => _vendor_name, "till_number" => _till_number} = params
      ) do
    %{"vendor_name" => _vendor_name, "till_number" => _till_number, "submit" => _submit_value} =
      params

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

  def view_vendor_profile(conn, %{"vendor_id" => vendor_id}) do
    vendor = Schools.get_vendor_by_id(vendor_id) |> dbg

    latest_sales =
      Schools.get_vendors_most_recent_sales(vendor)

    sallable_items =
      Schools.get_vendors_sallable_items(vendor)
      |> Enum.map(fn x ->
        unless is_nil(x.image) do
          Map.put(x, :image_path, "/media/#{Path.relative_to(x.image, "./output")}")
        else
          Map.put(x, :image_path, " ")
        end
      end)

    conn
    |> put_layout(html: :layout)
    |> render(:vendor_profile,
      vendor: vendor,
      latest_sales: latest_sales,
      sallable_items: sallable_items
    )
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
    # FIXME: (teddy)  Implement profile photo feature
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

  def edit_student(conn, %{"student_id" => student_id}) do
    token = Plug.CSRFProtection.get_csrf_token()

    student = Schools.get_student_by_id(student_id)

    classes_or_forms =
      conn.assigns[:current_user]
      |> Schools.fetch_school_record_for_user()
      |> Schools.list_classes_for_user()

    unless is_nil(student) do
      conn
      |> put_layout(html: :layout)
      |> render(:edit_student,
        token: token,
        student: student,
        classes: classes_or_forms,
        student_id: student_id
      )
    else
      conn
      |> send_resp(404, "Not Found")
    end
  end

  @spec update_student_profile_image(map()) :: String.t() | nil
  defp update_student_profile_image(%{"profile_image" => profile_image}) do
    # Do something important
    # FIXME: (teddy) on update, delete the previous image
    SchoolWeb.Utils.save_media(:student, profile_image)
  end

  @spec update_student_profile_image(map()) :: nil
  defp update_student_profile_image(_) do
    nil
  end

  def update_student(conn, %{"student_id" => student_id, "edit_student" => _} = params) do
    with student when not is_nil(student) <- Schools.get_student_by_id(student_id),
         {:ok, _} <- Schools.update_student(student, params, update_student_profile_image(params)) do
      conn
      |> redirect(to: ~p"/school/students")
    else
      _ ->
        conn
        |> send_resp(404, "NOT FOUND")
    end
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
