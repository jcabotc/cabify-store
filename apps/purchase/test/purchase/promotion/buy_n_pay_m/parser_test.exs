defmodule Purchase.Promotion.BuyNPayM.ParserTest do
  use ExUnit.Case, async: true

  alias Purchase.{Product, Promotion.BuyNPayM}

  test "parse/2" do
    name           = "3x2 foo"
    product        = Product.new(:foo, name: "foo", price: 1000)
    batch_size     = 3
    free_per_batch = 1

    built = BuyNPayM.new(name, product, batch_size, free_per_batch)

    config = [name:       name,
              product_id: :foo,
              buy:        3,
              pay:        2]
    products = [product]

    parsed = BuyNPayM.Parser.parse(config, products)

    assert built == parsed
  end
end
