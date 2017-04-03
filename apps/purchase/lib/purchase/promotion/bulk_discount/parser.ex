defmodule Purchase.Promotion.BulkDiscount.Parser do
  alias Purchase.{Product, Promotion.BulkDiscount}

  @type name       :: String.t
  @type product_id :: Product.id
  @type quantity   :: pos_integer
  @type bulk_price :: number

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
