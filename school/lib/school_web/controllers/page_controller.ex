defmodule SchoolWeb.PageController do
  use SchoolWeb, :controller

  def home(conn, _params) do
    user = conn.assigns[:current_user]

    unless is_nil(user) do
      redirect_to_user_dashboard(conn, user)
    else
      render(conn, :home, layout: false)
    end

    conn |> redirect_to_user_dashboard(user)
  end

  defp redirect_to_user_dashboard(conn, user) do
    conn
    |> redirect(to: School.Utils.redirect_route_based_on_user_type(user))
  end
end
