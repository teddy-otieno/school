defmodule SchoolWeb.ParentPage.PageController do
  alias School.Accounts
  use SchoolWeb, :controller


  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
  end

  def signup(conn, params) do

    Accounts.register_user()
    conn
  end
end
