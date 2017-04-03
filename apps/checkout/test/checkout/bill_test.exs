defmodule Checkout.BillTest do
  use ExUnit.Case, async: true

  alias Checkout.{Product, Discount, Basket, Bill}

  test "new/2 and add/2" do
    product_1 = Product.new(:foo, name: "foo", price: 10.0)
    product_2 = Product.new(:bar, name: "bar", price: 15.0)

    discount_1 = Discount.new(name: "baz", amount: 3)
    discount_2 = Discount.new(name: "qux", amount: 5)

    basket = Basket.new
             |> Basket.add(product_1)
             |> Basket.add(product_2)

    bill = Bill.new(basket)
    assert bill.total == 25.0

    bill = bill
           |> Bill.apply(discount_1)
           |> Bill.apply(discount_2)
    assert bill.total == 17.0

    bill = bill
           |> Bill.apply(discount_1)
           |> Bill.apply(discount_1)
    assert bill.total == 11.0
  end
end
