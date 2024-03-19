defmodule SchoolWeb.Vendors.Views.AccountState do
  alias School.Finances

  @type data_received() :: %{state: Finances.state()}
  @type response_type :: %{account_balance: String.t(), recent_transactions: list(any())}

  @spec show(data_received()) :: %{data: response_type()}
  def show(%{state: state}) do
    %{data: data(state)}
  end

  @spec data(Finances.state()) :: response_type()
  defp data(state) do
    %{
      account_balance: Money.to_string(state.balance),
      recent_transactions:
        for(trans <- state.recent, do: SchoolWeb.ParentPage.Views.Transaction.data(trans))
    }
  end
end
