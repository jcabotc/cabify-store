defmodule Purchase.ProductTest do
  use ExUnit.Case, async: true

  alias Purchase.Product

  test "new/2" do
    product = Product.new(:foo, name: "foo", price: 1000)

    assert product.id    == :foo
    assert product.name  == "foo"
    assert product.price == 1000
  end
end
