defmodule School.Parents do
  import Ecto.Query, warn: false
  alias School.Repo
  alias Ecto.Multi

  alias School.Accounts.User
  alias School.Parent.Parent

  def create_parent_account(params) do
    Multi.new()
    |> Multi.insert(
      :user,
      User.registration_changeset(
        %User{},
        Map.merge(params, %{
          "is_school" => false,
          "is_vendor" => false,
          "is_parent" => true,
          "is_admin" => false
        })
      )
    )
    |> Multi.insert(:parent, fn %{user: user} ->
      Parent.changeset(%Parent{}, %{"user_id" => user.id})
    end)
    |> Repo.transaction()
  end
end
