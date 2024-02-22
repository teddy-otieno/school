defmodule School.Utils do
  use SchoolWeb, :controller
  alias School.Accounts.User

  def redirect_route_based_on_user_type(%User{} = user) do

    case user do
      %{is_parent: true} -> ~p"/parent"
      %{is_school: true} -> ~p"/school/dash"

      _ -> ""
    end
  end
end
