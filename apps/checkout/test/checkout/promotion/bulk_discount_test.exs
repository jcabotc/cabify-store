defmodule Checkout.Promotion.BulkDiscountTest do
  use ExUnit.Case, async: true

  alias Checkout.{Product, Promotion}

  test "new/4" do
    name      = "3+ foo discount"
    product   = Product.new(:foo, name: "foo", price: 10.0)
    promotion = Promotion.BulkDiscount.new(name, product, 3, 2.0)

    assert promotion.name              == name
    assert promotion.product           == product
    assert promotion.quantity          == 3
    assert promotion.discount_per_unit == 2.0
  end
end
