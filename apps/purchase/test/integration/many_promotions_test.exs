defmodule Purchase.Integration.ManyPromotionsTest do
  use ExUnit.Case, async: true

  alias Purchase.Promotion.{BuyNPayM, BulkDiscount}

  @raw_rules [
    products: [
      foo: [name: "foo", price: 1000],
      bar: [name: "bar", price: 1500]],
    promotions: [
      {BuyNPayM, name:       "2x1 foo",
                 product_id: :foo,
                 buy:        2,
                 pay:        1},
      {BulkDiscount, name:       "3+ bar discount",
                     product_id: :bar,
                     quantity:   3,
                     bulk_price: 1200}]]

  test "build a bill" do
    purchase = @raw_rules
               |> Purchase.Rules.parse!
               |> Purchase.new

    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)

    bill = Purchase.bill(purchase)
    assert bill.total == (5 * 1000) + (4 * 1500) - (2 * 1000) - (4 * 300)
  end
end
