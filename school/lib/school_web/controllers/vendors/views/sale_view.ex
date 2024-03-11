defmodule SchoolWeb.Vendors.Views.SaleView do
  def show(%{sale_data: sale_data}) do
  	%{data: data(%{sale_data: sale_data})}
  end

  @doc """
  	sale_data will include 
  		- sale order
  		- journal
  		- sales_details
  		.
  		.
  		.
  		- some other data
  """
  def data(%{sale_data: sale_data}) do
  	%{}
  end
end
