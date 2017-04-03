defmodule Checkout do
  alias Checkout.{Rules, Product, Basket, Promotion, Bill}

  @type rules      :: Rules.t
  @type product    :: Product.t
  @type product_id :: Product.id
  @type basket     :: Basket.t

  @type t :: %__MODULE__{rules:  rules,
                         basket: basket}

  defstruct rules:  nil,
            basket: Basket.new

  @spec new(rules) :: t
  def new(%Rules{} = rules) do
    %Checkout{rules: rules}
  end

  @spec add(t, product_id) :: {:ok, product} | {:error, reason :: term}
  def add(%Checkout{rules: rules, basket: basket} = checkout, product_id) do
    case Rules.product(rules, product_id) do
      {:ok, product} ->
        new_basket = Basket.add(basket, product)
        {:ok ,%{checkout | basket: new_basket}}

      :unknown ->
        {:error, {:unknown_product_id, product_id}}
    end
  end

  def bill(%Checkout{rules: rules, basket: basket}) do
    rules.promotions
    |> Enum.reduce(Bill.new(basket), &Promotion.apply/2)
  end
end
