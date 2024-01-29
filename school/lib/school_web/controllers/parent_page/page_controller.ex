defmodule SchoolWeb.ParentPage.PageController do
  use SchoolWeb, :controller


  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
  end
end
