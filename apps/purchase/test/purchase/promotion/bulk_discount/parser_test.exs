defmodule Purchase.Promotion.BulkDiscount.ParserTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Promotion.BulkDiscount}

  test "parse/2" do
    name              = "4+ foo discount"
    product           = Product.new(:foo, name: "foo", price: 10.0)
    quantity          = 4
    discount_per_unit = 2.0

    built = BulkDiscount.new(name, product, quantity, discount_per_unit)

    config = [name:       name,
              product_id: :foo,
              quantity:   4,
              bulk_price: 8.0]
    products = [product]

    parsed = BulkDiscount.Parser.parse(config, products)

    assert built == parsed
  end
end
