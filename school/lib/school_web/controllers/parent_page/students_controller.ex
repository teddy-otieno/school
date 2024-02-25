defmodule SchoolWeb.ParentPage.StudentsController do
  use SchoolWeb, :controller
  alias School.Parents

  """
  We'll have to create accounts for students when the parent are assigned to them
  """

  def index(conn, _opts) do
    children =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Parents.get_parent_from_user()
      |> Parents.list_students_from_parent()

    conn
    |> put_view(json: SchoolWeb.ParentPage.Views.Student)
    |> render(:index, %{students: children})
  end

  def find_child(conn, %{"school_name" => school_name, "student_name" => student_name}) do
    result = Parents.find_child_in_schools(school_name, student_name)

    conn
    |> put_view(json: SchoolWeb.ParentPage.Views.FindChildView)
    |> render(:index, %{result: result})
  end

  def assign_to_parent(conn, %{"student_id" => student_id}) do
    result =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Parents.get_parent_from_user()
      |> Parents.assign_to_parent(student_id)

    with {:ok, updated_student} <- result do
      conn
      |> put_view(json: SchoolWeb.ParentPage.Views.Student)
      |> render(:show, %{student: updated_student})
    else
      _ ->
        conn
        |> send_resp(400, Jason.encode!(%{message: "Student not found"}))
    end
  end
end
