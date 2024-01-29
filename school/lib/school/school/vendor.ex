defmodule School.School.Vendor do
  use Ecto.Schema
  import Ecto.Changeset

  alias School.Accounts.User

  schema "vendors" do
    field :vendor_name, :string
    field :till_number, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vendor, attrs) do
    vendor
    |> cast(attrs, [:vendor_name, :till_number])
    |> validate_required([:vendor_name, :till_number])
  end
end
