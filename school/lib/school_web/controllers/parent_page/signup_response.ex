defmodule SchoolWeb.ParentPage.SignupResponse do
  alias School.Accounts.User

  def show(%{token: _, user: _} = data) do
    %{data: data(data)}
  end

  defp data(%{token: token, user: user_data}) do
    %User{
      id: id,
      email: email,
      first_name: first_name,
      last_name: last_name,
      is_parent: is_parent,
      is_vendor: is_vendor
    } = user_data

    %{
      token: token,
      email: email,
      id: id,
      first_name: first_name,
      last_name: last_name,
      is_parent: is_parent,
      is_vendor: is_vendor
    }
  end
end
