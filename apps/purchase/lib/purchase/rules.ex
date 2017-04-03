defmodule Purchase.Rules do
  alias __MODULE__
  alias Purchase.{Product, Promotion}

  @type product_id :: Product.id
  @type product    :: Product.t
  @type promotion  :: Promotion.t

  @type t :: %__MODULE__{products:       [product],
                         products_by_id: %{product_id => product},
                         promotions:     [promotion]}

  defstruct [:products, :products_by_id,
             :promotions]

  defdelegate parse!(),       to: Rules.Parser
  defdelegate parse!(config), to: Rules.Parser

  @spec new([product], [promotion]) :: t
  def new(products, promotions)
  when is_list(products) and is_list(promotions) do
    products_by_id = map_by_id(products)

    %Rules{products:       products,
           products_by_id: products_by_id,
           promotions:     promotions}
  end

  def product(%Rules{products_by_id: products_by_id}, product_id) do
    case Map.fetch(products_by_id, product_id) do
      {:ok, product} -> {:ok, product}
      :error         -> :unknown
    end
  end

  defp map_by_id(products) do
    for %Product{id: id} = product <- products, into: %{} do
      {id, product}
    end
  end
end
