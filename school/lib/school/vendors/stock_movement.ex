defmodule School.Vendors.StockMovement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stock_movement" do
    field :quantity, :integer
    field :comment, :string

    belongs_to :product, School.Vendors.Product, foreign_key: :product_id

    timestamps(type: :utc_datetime)
  end

  def changeset(movement, attrs) do
    movement
    |> cast(attrs, [:quantity, :comment, :product_id])
    |> validate_required([:quantity, :product_id])
  end
end
