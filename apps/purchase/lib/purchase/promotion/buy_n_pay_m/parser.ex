defmodule Purchase.Promotion.BuyNPayM.Parser do
  alias Purchase.{Product, Promotion.BuyNPayM}

  @type name       :: String.t
  @type product_id :: Product.id
  @type buy        :: pos_integer
  @type pay        :: non_neg_integer

  @type config :: [name:       name,
                   product_id: product_id,
                   buy:        buy,
                   pay:        pay]

  @type product :: Purchase.Product.t

  @spec parse(config, [product]) :: BuyNPayM.t
  def parse(config, products) do
    name       = Keyword.fetch!(config, :name)
    product_id = Keyword.fetch!(config, :product_id)
    buy        = Keyword.fetch!(config, :buy)
    pay        = Keyword.fetch!(config, :pay)

    product        = find!(products, product_id)
    batch_size     = buy
    free_per_batch = buy - pay

    BuyNPayM.new(name, product, batch_size, free_per_batch)
  end

  defp find!(products, product_id) do
    %Product{} = Enum.find(products, &(&1.id == product_id))
  end
end
