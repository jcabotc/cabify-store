defmodule Checkout.Integration.NoPromotionsTest do
  use ExUnit.Case, async: true

  @raw_rules [
    products: [
      foo: [name: "foo", price: 10.0],
      bar: [name: "bar", price: 15.0]],
    promotions: []]

  test "build a bill" do
    checkout = @raw_rules
               |> Checkout.Rules.parse!
               |> Checkout.new

    assert {:ok, checkout} = Checkout.add(checkout, :bar)
    assert {:ok, checkout} = Checkout.add(checkout, :foo)
    assert {:ok, checkout} = Checkout.add(checkout, :bar)

    bill = Checkout.bill(checkout)
    assert bill.total == 15.0 + 10.0 + 15.0
  end
end
