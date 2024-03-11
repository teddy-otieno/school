defmodule SchoolWeb.Vendors.SalesController do
  use SchoolWeb, :controller

  alias SchoolWeb.Vendors.DirectSaleSchema
  alias School.SalesProcessing
  alias School.Vendors
  alias School.School.Vendor

  def index(conn, _params) do
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
         {:ok, %{sale_order: sale_order} = some_data} <- SalesProcessing.initiate_direct_sale(valid_sale) do
      conn
      |> put_view(SchoolWeb.Vendors.Views.SaleView)
      |> render(:show, %{sale_data: some_data})
    else
      %Ecto.Changeset{valid?: false} = changeset ->
        conn
        |> SchoolWeb.Utils.send_error(changeset)

      {:invalid_quantity, _} ->
        conn
        |> send_resp(400, "Unable to return")
    end
  end
end
