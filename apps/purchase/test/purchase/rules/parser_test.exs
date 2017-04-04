defmodule Purchase.Rules.ParserTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Rules}

  defmodule TestPromotion do
    @behaviour Rules.Parser.Promotion

    defstruct [:config, :products]

    def parse(config, products) do
      %TestPromotion{config: config, products: products}
    end
  end

  @raw_rules [
    products: [
      foo: [name: "foo", price: 1000],
      bar: [name: "bar", price: 1500]],
    promotions: [
      {TestPromotion, [baz: "qux"]}]]

  test "parse!/1" do
    product_1 = Product.new(:foo, name: "foo", price: 1000)
    product_2 = Product.new(:bar, name: "bar", price: 1500)

    products  = [product_1, product_2]
    promotion = %TestPromotion{config: [baz: "qux"], products: products}

    expected_rules = Rules.new(products, [promotion])
    assert expected_rules == Rules.parse!(@raw_rules)
  end
end
