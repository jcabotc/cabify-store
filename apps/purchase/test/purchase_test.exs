defmodule PurchaseTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Rules}

  defmodule TestPromotion do
    defstruct [:discount_amount]
  end

  defimpl Purchase.Promotion, for: TestPromotion do
    alias Purchase.{Discount, Bill}

    def apply(%{discount_amount: amount}, bill) do
      discount = Discount.new(name: "test", amount: amount)
      Bill.apply(bill, discount)
    end
  end

  test "add/2 and bill/1" do
    product_1 = Product.new(:foo, name: "foo", price: 1000)
    product_2 = Product.new(:bar, name: "bar", price: 1500)
    products  = [product_1, product_2]

    promotion_1 = %TestPromotion{discount_amount: 200}
    promotion_2 = %TestPromotion{discount_amount: 400}
    promotions  = [promotion_1, promotion_2]

    rules    = Rules.new(products, promotions)
    purchase = Purchase.new(rules)

    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :bar)
    assert {:ok, purchase} = Purchase.add(purchase, :foo)

    bill = Purchase.bill(purchase)
    assert bill.total == 1500 + 1500 + 1000 - 200 - 400
  end
end
