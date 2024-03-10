defmodule SchoolWeb.Vendors.DirectSaleSchema do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :student_id, :integer
    field :vendor_id, :integer
    field :timestamp, :integer

    embeds_many :items, SchoolWeb.Vendors.ItemsToBeSold
  end

  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [:student_id, :vendor_id, :timestamp])
    |> cast_embed(:items, required: true)
    |> validate_required([:student_id, :vendor_id, :timestamp])
  end

  def validate_student_exists() do
  end
end

defmodule SchoolWeb.Vendors.ItemsToBeSold do
  alias School.SalesProcessing
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :product_id, :integer
    field :quantity, :integer
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:product_id, :quantity])
    |> validate_required([:product_id, :quantity])
    |> validate_change(:product_id, &validate_product_exists/2)
  end

  defp validate_product_exists(field_name, field) do
    # Check the database if the item exists

    unless SalesProcessing.does_product_exist?(field) do
      []
      |> Keyword.put(field_name, "Product not found")
    else
      []
    end
  end
end
