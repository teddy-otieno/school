defmodule SchoolWeb.Vendors.ProductPageController do
  use SchoolWeb, :controller

  alias School.Vendors

  def index(conn, _params) do
    vendor_items =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Vendors.get_vendor_from_current_user()
      |> Vendors.list_vendor_items()

    conn
    |> put_view(SchoolWeb.Vendors.Views.Product)
    |> render(:index, %{products: vendor_items})
  end

  def create(conn, %{"media" => file, "data" => data}) do
    params = Jason.decode!(data) |> dbg

    file |> dbg

    file_path = SchoolWeb.Utils.save_media(:product_item, file) |> dbg

    new_product_result =
      conn
      |> School.Guardian.Plug.current_resource()
      |> Vendors.get_vendor_from_current_user()
      |> Vendors.create_product_item(params, file_path)

    case new_product_result do
      {:ok, product} ->
        conn
        |> put_view(SchoolWeb.Vendors.Views.Product)
        |> render(:show, %{product: product})

      {:error, changeset} ->
        # Delete the image file when the saving fails
        SchoolWeb.Utils.remove_media(file_path)

        conn
        |> SchoolWeb.Utils.send_error(changeset)
    end
  end
end
