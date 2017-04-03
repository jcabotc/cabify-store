defmodule Purchase.DiscountTest do
  use ExUnit.Case, async: true

  alias Purchase.Discount

  test "new/2" do
    discount = Discount.new(name: "foo", amount: 1000)

    assert discount.name   == "foo"
    assert discount.amount == 1000
  end
end
