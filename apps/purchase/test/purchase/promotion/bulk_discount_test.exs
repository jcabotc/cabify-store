defmodule Purchase.Promotion.BulkDiscountTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Discount, Basket, Bill, Promotion}

  test "new/4" do
    name      = "3+ foo discount"
    product   = Product.new(:foo, name: "foo", price: 10.0)
    promotion = Promotion.BulkDiscount.new(name, product, 3, 2.0)

    assert promotion.name              == name
    assert promotion.product           == product
    assert promotion.quantity          == 3
    assert promotion.discount_per_unit == 2.0
  end

  describe "Purchase.Promotion implementation" do
    test "promotion not applicable" do
      name      = "3+ foo discount"
      product   = Product.new(:foo, name: "foo", price: 10.0)
      another   = Product.new(:bar, name: "bar", price: 15.0)
      promotion = Promotion.BulkDiscount.new(name, product, 3, 2.0)

      bill = Basket.new
             |> Basket.add(product)
             |> Basket.add(product)
             |> Basket.add(another)
             |> Bill.new

      new_bill = Promotion.apply(promotion, bill)
      assert new_bill.discounts == []
    end

    test "promotion applicable" do
      name      = "2+ foo discount"
      product   = Product.new(:foo, name: "foo", price: 10.0)
      another   = Product.new(:bar, name: "bar", price: 15.0)
      promotion = Promotion.BulkDiscount.new(name, product, 2, 2.0)

      bill = Basket.new
             |> Basket.add(product)
             |> Basket.add(another)
             |> Basket.add(another)
             |> Basket.add(product)
             |> Basket.add(product)
             |> Bill.new

      new_bill = Promotion.apply(promotion, bill)

      expected_discount = Discount.new(name: name, amount: 3 * 2.0)
      assert new_bill.discounts == [expected_discount]
    end
  end
end
