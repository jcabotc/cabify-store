defmodule Checkout.ProductTest do
  use ExUnit.Case, async: true

  alias Checkout.Product

  test "new/2" do
    product = Product.new(:foo, name: "foo", price: 10.0)

    assert product.id    == :foo
    assert product.name  == "foo"
    assert product.price == 10.0
  end
end
