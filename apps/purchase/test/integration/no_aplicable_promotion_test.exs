defmodule Purchase.Integration.NoApplicablePromotionTest do
  use ExUnit.Case, async: true

  alias Purchase.Promotion.BuyNPayM

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
    purchase = @raw_rules
               |> Purchase.Rules.parse!
               |> Purchase.new

    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)

    bill = Purchase.bill(purchase)
    assert bill.total == (2 * 10.0) + (3 * 15.0)
  end
end
