defmodule SchoolWeb.Vendors.Views.SaleView do
  alias School.SalesProcessing.SaleOrder
  alias School.School.Student
  alias School.SalesProcessing.SaleOrderDetails
  alias School.Vendors.Product

  def index(%{sales: completed_sales}) do
    %{
      data: for(sale <- completed_sales, do: data(sale))
    }
  end

  def show(%{sale: sale}) do
    %{data: data(sale)}
  end
  
  def data(%SaleOrder{student: %Student{}} = completed_sale) do
    student = completed_sale.student

    %{
      id: completed_sale.id,
      inserted_at: completed_sale.inserted_at,
      items: for(item <- completed_sale.items, do: render_item(item)),
      student: %{
        id: completed_sale.student.id,
        first_name: student.first_name,
        last_name: student.last_name
      }
    }
  end

  defp render_item(%SaleOrderDetails{product: %Product{}} = item) do
    %{
      id: item.id,
      purchase_price: Money.to_string(item.purchase_price),
      quantity: item.quantity,
      total: Money.to_string(Money.multiply(item.purchase_price, item.quantity)),
      product: %{
        id: item.product.id,
        description: item.product.description,
        image: item.product.image
      }
    }
  end
end
