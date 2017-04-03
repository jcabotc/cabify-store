defmodule Checkout.Promotion.BuyNPayMTest do
  use ExUnit.Case, async: true

  alias Checkout.{Product, Promotion}

  test "new/4" do
    name      = "3x2 foo"
    product   = Product.new(:foo, name: "foo", price: 10.0)
    promotion = Promotion.BuyNPayM.new(name, product, 3, 1)

    assert promotion.name           == name
    assert promotion.product        == product
    assert promotion.batch_size     == 3
    assert promotion.free_per_batch == 1
  end
end
