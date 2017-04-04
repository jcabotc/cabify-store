defmodule Purchase.Basket do
  @moduledoc "A model that represents a collection of products to be purchased"

  alias __MODULE__
  alias Purchase.Product

  @type product :: Product.t

  @type t :: %__MODULE__{products: [product]}

  defstruct products: []

  @spec new() :: t
  def new() do
    %Basket{}
  end

  @spec add(t, product) :: t
  def add(%Basket{products: products} = basket, %Product{} = product) do
    %{basket | products: [product | products]}
  end

  @doc "All products in the order they were added"
  @spec products(t) :: [product]
  def products(%Basket{products: products}) do
    Enum.reverse(products)
  end
end
