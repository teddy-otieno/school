defmodule SchoolWeb.Vendors.Views.StockQuantity do
  alias SchoolWeb.Vendors.Views.Product

  def index(%{quantities: quantities}) do
    %{
      data:
        for product <- quantities do
          data(product)
        end
    }
  end

  def show(%{stock_quantity: stock_quantity}) do
    %{data: data(stock_quantity)}
  end

  def data(stock_quantity) do
    %{
      product: Product.data(stock_quantity.product),
      quantity: stock_quantity.quantity
    }
  end
end
