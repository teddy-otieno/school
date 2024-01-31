defmodule School.Schools do
  @moduledoc """
  The schools context
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi

  alias School.Accounts.User
  alias School.Repo
  alias School.School.Vendor
  alias School.School

  def setup_school(%User{} = user, params) do
    params_with_account_manager = Map.put(params, "account_manager_id", user.id)

    %School{}
    |> School.changeset(params_with_account_manager)
    |> Repo.insert()
  end

  def find_school_setup_by_user(%User{} = user) do
    Repo.get_by(School, account_manager_id: user.id)
  end

  def create_vendor(school = %School{}, params) do
    params_with_added_user_type =
      Map.merge(params, %{
        "is_parent" => false,
        "is_admin" => false,
        "is_vendor" => true,
        "is_student" => false,
        "is_school" => false
      })

    Multi.new()
    |> Multi.insert(:user, User.registration_changeset(%User{}, params_with_added_user_type))
    |> Multi.insert(:vendor, fn %{user: user = %User{}} ->
      Vendor.changeset(
        %Vendor{},
        Map.merge(params, %{"user_id" => user.id, "school_id" => school.id})
      )
    end)
    |> Repo.transaction()
  end

  def fetch_all_vendors(school = %School{}) do
    query =
      from v in Vendor,
        where: v.school_id == ^school.id and not is_nil(v.user_id),
        preload: [:user],
        select: v

    Repo.all(query)
  end

  def fetch_school_record_for_user(user = %User{}) do
    query = from s in School, where: s.account_manager_id == ^user.id, select: s

    Repo.one!(query)
    |> dbg
  end
end
