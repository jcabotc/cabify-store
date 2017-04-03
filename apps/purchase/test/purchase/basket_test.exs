defmodule Purchase.BasketTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Basket}

  test "new/2" do
    product_1 = Product.new(:foo, name: "foo", price: 10.0)
    product_2 = Product.new(:bar, name: "bar", price: 15.0)

    basket = Basket.new
             |> Basket.add(product_1)
             |> Basket.add(product_1)
             |> Basket.add(product_2)

    expected_products = [product_1, product_1, product_2]
    assert expected_products == Basket.products(basket)
  end
end
