defmodule SchoolWeb.Vendors.Views.StockMovement do
  alias School.Vendors.StockMovement

  def show(%{movement: movement}) do
    %{data: data(movement)}
  end

  def data(%StockMovement{} = movement) do
    #NOTE: (Teddy) WE'll return the necessary data to the mobile application
    %{id: movement.id, comment: movement.comment, quantity: movement.quantity}
  end
end
