defmodule SchoolWeb.PageController do
  use SchoolWeb, :controller

  def home(conn, _params) do
    user = conn.assigns[:current_user]

    conn |> redirect_to_user_dashboard(user)
  end

  defp redirect_to_user_dashboard(conn, nil) do
    render(conn, :home, layout: false, name: "Teddy")
  end

  defp redirect_to_user_dashboard(conn, user) do
    case user do
      %{is_school: true} ->
        conn |> redirect(to: ~p"/school/dash")

      _ ->
        conn
        |> render(:home, layout: false, name: "SOmething else")
    end

  end
end
