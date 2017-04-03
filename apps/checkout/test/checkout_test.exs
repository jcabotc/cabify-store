defmodule CheckoutTest do
  use ExUnit.Case, async: true

  alias Checkout.{Product, Rules}

  defmodule TestPromotion do
    defstruct [:discount_amount]
  end

  defimpl Checkout.Promotion, for: TestPromotion do
    alias Checkout.{Discount, Bill}

    def apply(%{discount_amount: amount}, bill) do
      discount = Discount.new(name: "test", amount: amount)
      Bill.apply(bill, discount)
    end
  end

  test "add/2 and bill/1" do
    product_1 = Product.new(:foo, name: "foo", price: 10.0)
    product_2 = Product.new(:bar, name: "bar", price: 15.0)
    products  = [product_1, product_2]

    promotion_1 = %TestPromotion{discount_amount: 2.0}
    promotion_2 = %TestPromotion{discount_amount: 4.0}
    promotions  = [promotion_1, promotion_2]

    rules    = Rules.new(products, promotions)
    checkout = Checkout.new(rules)

    assert {:ok, checkout} = Checkout.add(checkout, :bar)
    assert {:ok, checkout} = Checkout.add(checkout, :bar)
    assert {:ok, checkout} = Checkout.add(checkout, :foo)

    bill = Checkout.bill(checkout)
    assert bill.total == 15.0 + 15.0 + 10.0 - 2.0 - 4.0
  end
end
