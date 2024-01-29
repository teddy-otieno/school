defmodule School.Schools do
  @moduledoc """
  The schools context
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi

  alias School.Accounts.User
  alias School.Repo
  alias School.School
  alias School.Schools.Vendor
  alias School.Accounts

  def setup_school(%User{} = user, params) do
    params_with_account_manager = Map.put(params, "account_manager_id", user.id)

    %School{}
    |> School.changeset(params_with_account_manager)
    |> Repo.insert()
  end

  def find_school_setup_by_user(%User{} = user) do
    Repo.get_by(School, account_manager_id: user.id)
  end

  def create_vendor(params) do
    Multi.new()
    |> Multi.insert(:users, User.registration_changeset(params))
    |> Multi.insert(:vendors, Vendor.changeset(params))
    |> Repo.transaction
  end
end
