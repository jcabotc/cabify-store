defmodule Purchase.Integration.NoPromotionsTest do
  use ExUnit.Case, async: true

  @raw_rules [
    products: [
      foo: [name: "foo", price: 10.0],
      bar: [name: "bar", price: 15.0]],
    promotions: []]

  test "build a bill" do
    purchase = @raw_rules
               |> Purchase.Rules.parse!
               |> Purchase.new

    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)

    bill = Purchase.bill(purchase)
    assert bill.total == 15.0 + 10.0 + 15.0
  end
end
