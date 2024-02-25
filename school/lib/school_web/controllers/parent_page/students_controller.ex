defmodule SchoolWeb.ParentPage.StudentsController do
  use SchoolWeb, :controller

  def index(conn, _opts) do
    conn
    |> send_resp(200, "Hello world")
  end
end
