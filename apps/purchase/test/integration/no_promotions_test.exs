defmodule Purchase.Integration.NoPromotionsTest do
  use ExUnit.Case, async: true

  @raw_rules [
    products: [
      foo: [name: "foo", price: 1000],
      bar: [name: "bar", price: 1500]]]

  test "build a bill" do
    purchase = @raw_rules
               |> Purchase.Rules.parse!
               |> Purchase.new

    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)

    bill = Purchase.bill(purchase)
    assert bill.total == 1500 + 1000 + 1500
  end
end
