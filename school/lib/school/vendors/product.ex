defmodule School.Vendors.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.School.Vendor

  schema "product_items" do
    field :product_name, :string
    field :description, :string
    field :price, Money.Ecto.Composite.Type
    field :purchase_date, :utc_datetime
    field :image, :string

    belongs_to :vendor, Vendor, foreign_key: :vendor_id

    timestamps(type: :utc_datetime)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:product_name, :description, :price, :purchase_date, :vendor_id, :image])
    |> validate_required([:product_name, :description, :price, :purchase_date, :vendor_id, :image])
    |> unique_constraint(:product_name, name: "product_items_product_name_index")
  end
end
