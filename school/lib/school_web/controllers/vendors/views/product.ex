defmodule SchoolWeb.Vendors.Views.Product do
  alias School.Vendors.Product

  def index(%{products: products}) do
    %{data: for(p <- products, do: data(p))}
  end

  def show(%{product: product}) do
    %{data: data(product)}
  end

  def data(%Product{} = product) do
    {price, _other} = Float.parse(Money.to_string(product.price, symbol: false))
    %{
      id: product.id,
      product_name: product.product_name,
      price: Money.to_string(product.price),
      price_raw: price,
      purchase_date: product.purchase_date,
      inserted_at: product.inserted_at,
      updated_at: product.updated_at,
      image:
        unless(is_nil(product.image),
          do: "media/" <> Path.relative_to(product.image, "./output"),
          else: nil
        )
    }
  end
end
