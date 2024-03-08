defmodule SchoolWeb.Vendors.StocksController do
  use SchoolWeb, :controller

  alias School.Vendors

  def index(conn, _params) do
    output =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Vendors.get_vendor_from_current_user()
      |> Vendors.list_stock_quantities()

    conn
    |> put_view(SchoolWeb.Vendors.Views.StockQuantity)
    |> render(:index, %{quantities: output})
  end

  def create(conn, params) do
    with {:ok, movement} <- Vendors.create_stock_movement_entry(params) do
      conn
      |> put_view(SchoolWeb.Vendors.Views.StockMovement)
      |> render(:show, %{movement: movement})
    else
      {:error, changeset} ->
        conn
        |> SchoolWeb.Utils.send_error(changeset)
    end
  end

  def list_all_products_with_quantities(conn, _params) do
    output =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Vendors.get_vendor_from_current_user()
      |> Vendors.list_all_products_and_quantities()

    conn
    |> put_view(SchoolWeb.Vendors.Views.StockQuantity)
    |> render(:index, %{quantities: output})
  end
end
