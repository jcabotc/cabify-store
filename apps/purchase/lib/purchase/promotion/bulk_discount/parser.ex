defmodule Purchase.Promotion.BulkDiscount.Parser do
  @moduledoc """
  Module that parses the BulkDiscount configuration
  into a BulkDiscount struct
  """

  alias Purchase.{Product, Promotion.BulkDiscount}

  @typedoc "A human-readable description of the discount"
  @type name :: String.t

  @typedoc "The id of the product to apply the discount to"
  @type product_id :: Product.id

  @typedoc "The minimum quantity of units to apply the discount"
  @type quantity :: pos_integer

  @typedoc "The price of the product when the discount applies"
  @type bulk_price :: integer

  @type config :: [name:       name,
                   product_id: product_id,
                   quantity:   quantity,
                   bulk_price: bulk_price]

  @type product :: Purchase.Product.t

  @spec parse(config, [product]) :: BulkDiscount.t
  def parse(config, products) do
    name       = Keyword.fetch!(config, :name)
    product_id = Keyword.fetch!(config, :product_id)
    quantity   = Keyword.fetch!(config, :quantity)
    bulk_price = Keyword.fetch!(config, :bulk_price)

    product           = find!(products, product_id)
    discount_per_unit = product.price - bulk_price

    BulkDiscount.new(name, product, quantity, discount_per_unit)
  end

  defp find!(products, product_id) do
    %Product{} = Enum.find(products, &(&1.id == product_id))
  end
end
