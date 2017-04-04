defmodule Purchase.Rules do
  @moduledoc """
  It represents the rules to apply to the purchasing process

  To simplify the process of building the rules a parse!/1 function is
  provided to parse configuration into a `Purchase.Rules` struct:

  ```elixir
  alias Purchase.Promotion.BuyNPayM

  config = [
    products: [
      foo: [name: "Foo", price: 1000],
      bar: [name: "Bar", price: 2000]],
    promotions: [
      {BuyNPayM, name: "2 for 1 foo", product_id: :foo, buy: 2, pay: 1}]]

  rules = Purchase.Rules.parse!(config)
  ```
  """

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

  @raw_rules Application.get_env(:purchase, :rules, [])
  defdelegate parse!(raw_rules \\ @raw_rules), to: Rules.Parser

  @doc """
  Create a rules struct.

  It receives the collection of available products as first argument,
  and the list of active promotions as the second argument.
  """
  @spec new([product], [promotion]) :: t
  def new(products, promotions)
  when is_list(products) and is_list(promotions) do
    products_by_id = map_by_id(products)

    %Rules{products:       products,
           products_by_id: products_by_id,
           promotions:     promotions}
  end

  @doc "Find a product by product id"
  @spec product(t, product_id) :: {:ok, product} | :unknown
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
