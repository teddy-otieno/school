defmodule SchoolWeb.ParentPage.Views.Transaction do
  alias School.Money.Journal
  alias School.Money.AccountTransactions

  @spec index(%{transactions: list(AccountTransactions)}) :: any()
  def index(%{transactions: transactions}) do
    %{data: for(t <- transactions, do: data(t))}
  end

  def data(%AccountTransactions{} = transaction) do
    %{
      id: transaction.id,
      comment: transaction.comment,
      debit: transaction.debit |> Money.to_string(),
      credit: transaction.credit |> Money.to_string(),
      inserted_at: transaction.inserted_at,
      debit_entry:
        unless is_nil(transaction.debit_entry) do
          %Journal{} = entry = transaction.debit_entry
          %{comment: entry.description, id: entry.id}
        else
          nil
        end,
      credit_entry:
        unless is_nil(transaction.credit_entry) do
          %Journal{} = entry = transaction.credit_entry
          %{comment: entry.description, id: entry.id}
        else
          nil
        end
    }
  end
end
