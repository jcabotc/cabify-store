defmodule Purchase.Promotion.BuyNPayMTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Discount, Basket, Bill, Promotion}

  test "new/4" do
    name      = "3x2 foo"
    product   = Product.new(:foo, name: "foo", price: 10.0)
    promotion = Promotion.BuyNPayM.new(name, product, 3, 1)

    assert promotion.name           == name
    assert promotion.product        == product
    assert promotion.batch_size     == 3
    assert promotion.free_per_batch == 1
  end

  describe "Purchase.Promotion implementation" do
    test "promotion not applicable" do
      name      = "3x2 foo"
      product   = Product.new(:foo, name: "foo", price: 10.0)
      promotion = Promotion.BuyNPayM.new(name, product, 3, 1)

      bill = Basket.new
             |> Basket.add(product)
             |> Basket.add(product)
             |> Bill.new

      new_bill = Promotion.apply(promotion, bill)
      assert new_bill.discounts == []
    end

    test "promotion applicable" do
      name      = "2x1 foo"
      product   = Product.new(:foo, name: "foo", price: 10.0)
      another   = Product.new(:bar, name: "bar", price: 15.0)
      promotion = Promotion.BuyNPayM.new(name, product, 2, 1)

      bill = Basket.new
             |> Basket.add(product)
             |> Basket.add(another)
             |> Basket.add(product)
             |> Basket.add(product)
             |> Basket.add(product)
             |> Basket.add(product)
             |> Bill.new

      new_bill = Promotion.apply(promotion, bill)

      expected_discount = Discount.new(name: name, amount: 2 * 10)
      assert new_bill.discounts == [expected_discount]
    end
  end
end
