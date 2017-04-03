defmodule Purchase.BillTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Discount, Basket, Bill}

  test "new/2 and add/2" do
    product_1 = Product.new(:foo, name: "foo", price: 1000)
    product_2 = Product.new(:bar, name: "bar", price: 1500)

    discount_1 = Discount.new(name: "baz", amount: 300)
    discount_2 = Discount.new(name: "qux", amount: 500)

    basket = Basket.new
             |> Basket.add(product_1)
             |> Basket.add(product_2)

    bill = Bill.new(basket)
    assert bill.total == 2500

    bill = bill
           |> Bill.apply(discount_1)
           |> Bill.apply(discount_2)
    assert bill.total == 1700

    bill = bill
           |> Bill.apply(discount_1)
           |> Bill.apply(discount_1)
    assert bill.total == 1100

    expected_products = [product_1, product_2]
    expected_discounts = [discount_1, discount_2, discount_1, discount_1]

    assert expected_products  == Bill.products(bill)
    assert expected_discounts == Bill.discounts(bill)
  end
end
