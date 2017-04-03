defmodule Checkout.Rules.Parser do
  alias Checkout.{Product, Rules}

  defmodule Promotion do
    @type config    :: Keyword.t
    @type product   :: Checkout.Product.t
    @type promotion :: Checkout.Promotion.t

    @callback parse(config, [product]) :: promotion
  end

  @type product_id         :: Product.id
  @type product_attributes :: Product.attributes

  @type promotion_mod    :: module
  @type promotion_config :: Rules.Parser.Promotion.config

  @type raw_product   :: {product_id, product_attributes}
  @type raw_promotion :: {promotion_mod, promotion_config}

  @type raw_rules :: [products:   [raw_product],
                      promotions: [raw_promotion]]

  @spec parse!(raw_rules) :: Rules.t
  def parse!(raw_rules) do
    products   = build_products(raw_rules)
    promotions = build_promotions(raw_rules, products)

    Rules.new(products, promotions)
  end

  defp build_products(raw_rules) do
    raw_rules
    |> Keyword.fetch!(:products)
    |> Enum.map(fn {id, config} -> Product.new(id, config) end)
  end

  defp build_promotions(raw_rules, products) do
    raw_rules
    |> Keyword.fetch!(:promotions)
    |> Enum.map(fn {mod, config} -> mod.parse(config, products) end)
  end
end
