defmodule School.School.Vendor do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Vendors.Product
  alias School.Accounts.User
  alias School.School

  schema "vendors" do
    field :vendor_name, :string
    field :till_number, :string

    timestamps(type: :utc_datetime)

    belongs_to :user, User
    belongs_to :school, School
    has_many(:products, Product, foreign_key: :vendor_id, references: :id)
  end

  @doc false
  def changeset(vendor, attrs) do
    vendor
    |> cast(attrs, [:vendor_name, :till_number, :user_id, :school_id])
    |> validate_required([:vendor_name, :till_number, :user_id, :school_id])
  end
end
