defmodule SchoolWeb.MediaController do
  use SchoolWeb, :controller

  def show(conn, %{"path" => path, "file" => file}) do
    file_path = Path.join(["./output", path, file])

    if File.exists?(file_path) do
      conn
      |> put_resp_content_type("image/jpeg")
      |> send_file(200, file_path)
    else
      conn
      |> send_resp(404, "Not Found")
    end
  end
end
