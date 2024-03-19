defmodule SchoolWeb.Vendors.SalesController do
  use SchoolWeb, :controller

  alias SchoolWeb.Vendors.DirectSaleSchema
  alias School.SalesProcessing
  alias School.Vendors
  alias School.School.Vendor
  alias School.Finances

  @doc """
  List all the sales
  """
  def index(conn, _params) do
    completed_sales =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Vendors.get_vendor_from_current_user()
      |> Vendors.list_all_complete_sales()

    conn
    |> put_view(SchoolWeb.Vendors.Views.SaleView)
    |> render(:index, %{sales: completed_sales})
  end

  @doc """
  Handle new sale
  """
  def create(conn, params) do
    %Vendor{id: vendor_id} =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Vendors.get_vendor_from_current_user()

    with %Ecto.Changeset{valid?: true} = valid_sale <-
           DirectSaleSchema.changeset(%DirectSaleSchema{vendor_id: vendor_id}, params),
         {:ok, %{sale_order: sale_order, total_sale_value: total_sale_value}} <-
           SalesProcessing.initiate_direct_sale(valid_sale) do
      sale_order_with_preloaded_assoc =
        School.Repo.preload(sale_order, items: [:product], student: [])

      conn
      |> put_view(SchoolWeb.Vendors.Views.SaleView)
      |> render(:show, %{sale: {sale_order_with_preloaded_assoc, total_sale_value}})
    else
      %Ecto.Changeset{valid?: false} = changeset ->
        conn
        |> SchoolWeb.Utils.send_error(changeset)

      {:invalid_quantity, _} ->
        conn
        |> send_resp(400, "Unable to return")
    end
  end

  def get_account_state(conn, _params) do
    state =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Vendors.get_vendor_from_current_user()
      |> Finances.get_vendor_account_state()

    conn
    |> put_view(SchoolWeb.Vendors.Views.AccountState)
    |> render(:show, %{state: state})
  end
end
