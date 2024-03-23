defmodule SchoolWeb.ParentPage.PageController do
  use SchoolWeb, :controller
  alias SchoolWeb.ParentPage.Views.Informatics
  alias School.Accounts
  alias School.Parents

  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
  end

  def signup(conn, params) do
    with {:ok, %{user: user}} <- Parents.create_parent_account(params) do
      # NOTE: (teddy) send token
      {:ok, token, claims} = School.Guardian.encode_and_sign(user)

      conn
      |> put_view(json: SchoolWeb.ParentPage.SignupResponse)
      |> render(:show, %{token: token, user: user})
    else
      {:error, _name, changes, _} ->
        errors =
          changes.errors
          |> Enum.map(fn {key, {caption, _other}} -> [to_string(key), caption] end)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{errors: errors})
        )
    end
  end

  def parent_informatics(conn, _params) do
    informatics_result =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Parents.get_parent_from_user()
      |> Parents.get_parent_informatics()

    conn
    |> put_view(Informatics)
    |> render(:show, informatics: informatics_result)
  end

  def profile(conn, _params) do
    conn
    |> send_resp(200, "Hello world")
  end
end
