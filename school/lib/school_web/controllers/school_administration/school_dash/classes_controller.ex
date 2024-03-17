defmodule SchoolWeb.SchoolAdministration.SchoolDash.ClassesController do
  use SchoolWeb, :controller

  alias School.Schools

  def list_students(conn, %{"class_id" => class_id}) do
    class = class_id |> Schools.get_class_by_id() |> dbg

    if is_nil(class) do
      # TODO: (teddy) handle this error in a better way
      conn
      |> send_resp(404, "Not Found")
    else
      students = class.students
      conn
      |> put_layout(html: :layout)
      |> render(:list_class_of_students, class: class, students: students)
    end
  end
end
