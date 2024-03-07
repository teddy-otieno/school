defmodule School.Vendors do
  import Ecto.Query, warn: false
  alias School.Repo

  alias School.Vendors.Product
  alias School.School.Vendor
  alias School.Accounts.User

  def list_vendor_items(%Vendor{id: id}) do
    query = from(p in Product, where: p.vendor_id == ^id)

    query
    |> Repo.all()
  end

  def get_vendor_from_current_user(%User{id: id}) do
    query = from(v in Vendor, where: v.user_id == ^id)

    query
    |> Repo.one!()
  end

  def create_product_item(%Vendor{id: vendor_id}, attrs, image_path) do
    update_attributes =
      attrs
      |> Map.put("vendor_id", vendor_id)
      |> Map.put("price", Money.new(attrs["price"] * 100))
      |> Map.put("image", image_path)

    %Product{}
    |> Product.changeset(update_attributes)
    |> Repo.insert()
  end
end
