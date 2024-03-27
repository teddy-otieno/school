defmodule SchoolWeb.ParentPage.Views.ParentProfile do
  alias School.Money.AccountTransactions
  alias School.Parents

  @type journal_transaction_response() :: %{}

  @spec show(%{parent_profile: Parents.profile_data()}) :: %{data: journal_transaction_response()}
  def show(%{parent_profile: parent_profile}) do
    dbg(parent_profile)
    %{data: data(parent_profile)}
  end

  @spec data(Parents.profile_data()) :: journal_transaction_response()
  defp data(profile_data) do
    %{
      transactions: profile_data.transaction_history |> Enum.map(&render_journal_entries/1),
      name: "#{profile_data.parent.user.first_name} #{profile_data.parent.user.last_name}"
    } |> dbg
  end

  defp render_journal_entries(%AccountTransactions{} = entry) do
    %{
      id: entry.id,
      debit: entry.debit |> Money.to_string(),
      credit: entry.credit |> Money.to_string(),
      type: if(is_nil(entry.debit_entry), do: "CREDIT", else: "DEBIT"),
      comment:
        unless(is_nil(entry.debit_entry),
          do: entry.debit_entry.description,
          else: entry.credit_entry.description
        ),
      inserted_at: entry.inserted_at,
      updated_at: entry.updated_at
    }
  end
end
