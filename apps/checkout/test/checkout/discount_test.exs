defmodule Checkout.DiscountTest do
  use ExUnit.Case, async: true

  alias Checkout.Discount

  test "new/2" do
    discount = Discount.new(name: "foo", amount: 10.0)

    assert discount.name   == "foo"
    assert discount.amount == 10.0
  end
end
