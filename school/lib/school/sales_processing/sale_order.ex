defmodule School.SalesProcessing.SaleOrder do
  @moduledoc """
    field :memo, :string
    field :timestamp, :integer

    belongs_to(:student, School.School.Student, foreign_key: :student_id)
    belongs_to(:vendor, School.School.Vendor, foreign_key: :vendor_id)
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias School.SalesProcessing.SaleOrderDetails
  alias School.SalesProcessing.SaleOrder

  schema "sales_orders" do
    field :memo, :string
    field :timestamp, :integer
    timestamps(type: :utc_datetime)

    belongs_to(:student, School.School.Student, foreign_key: :student_id)
    belongs_to(:vendor, School.School.Vendor, foreign_key: :vendor_id)

    has_many(:items, SaleOrderDetails, foreign_key: :sales_order_id, references: :id)
  end

  def changeset(%SaleOrder{} = order, attrs) do
    order
    |> cast(attrs, [:memo, :timestamp, :student_id, :vendor_id])
    |> validate_required([:timestamp, :student_id, :vendor_id])
  end
end
