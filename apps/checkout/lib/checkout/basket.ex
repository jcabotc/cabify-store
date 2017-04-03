defmodule Checkout.Basket do
  alias __MODULE__
  alias Checkout.Product

  @type product :: Product.t

  @type t :: %__MODULE__{products:  [product]}

  defstruct products: []

  @spec new() :: t
  def new() do
    %Basket{}
  end

  @spec add(t, product) :: t
  def add(%Basket{products: products} = basket, %Product{} = product) do
    %{basket | products: [product | products]}
  end

  @spec products(t) :: [product]
  def products(%Basket{products: products}) do
    Enum.reverse(products)
  end
end
