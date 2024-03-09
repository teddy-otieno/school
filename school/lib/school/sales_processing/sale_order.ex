defmodule School.SalesProcessing.SaleOrder do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.SalesProcessing.SaleOrder

  schema "sales_orders" do
    field :memo, :string

    belongs_to(:student, School.School.Student, foreign_key: :student_id)
    belongs_to(:vendor, School.School.Vendor, foreign_key: :vendor_id)

    timestamps(type: :utc_datetime)
  end

  def changeset(%SaleOrder{} = order, attrs) do
    order
    |> cast(attrs, [:memo, :student_id, :vendor_id])
    |> validate_required([:student_id, :vendor_id])
  end
end
