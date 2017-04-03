defmodule Checkout.Integration.NoApplicablePromotionTest do
  use ExUnit.Case, async: true

  alias Checkout.Promotion.BuyNPayM

  @raw_rules [
    products: [
      foo: [name: "foo", price: 10.0],
      bar: [name: "bar", price: 15.0]],
    promotions: [
      {BuyNPayM, name:       "3x2 foo",
                 product_id: :foo,
                 buy:        3,
                 pay:        2}]]

  test "build a bill" do
    checkout = @raw_rules
               |> Checkout.Rules.parse!
               |> Checkout.new

    assert {:ok, checkout} = Checkout.add(checkout, :foo)
    assert {:ok, checkout} = Checkout.add(checkout, :foo)
    assert {:ok, checkout} = Checkout.add(checkout, :bar)
    assert {:ok, checkout} = Checkout.add(checkout, :bar)
    assert {:ok, checkout} = Checkout.add(checkout, :bar)

    bill = Checkout.bill(checkout)
    assert bill.total == (2 * 10.0) + (3 * 15.0)
  end
end
