defmodule Purchase.RulesTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Rules}

  test "new/2 and product/2" do
    product_1 = Product.new(:foo, name: "foo", price: 1000)
    product_2 = Product.new(:bar, name: "bar", price: 1500)

    products   = [product_1, product_2]
    promotions = [:fake_promotion]

    rules = Rules.new(products, promotions)

    assert rules.products   == products
    assert rules.promotions == promotions

    assert {:ok, product_2} == Rules.product(rules, :bar)
    assert :unknown         == Rules.product(rules, :baz)
  end
end
