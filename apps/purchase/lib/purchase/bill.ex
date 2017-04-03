defmodule Purchase.Bill do
  alias __MODULE__
  alias Purchase.{Basket, Discount}

  @type basket   :: Basket.t
  @type product  :: Product.t
  @type discount :: Discount.t
  @type total    :: integer

  @type t :: %__MODULE__{basket:    basket,
                         discounts: [discount],
                         total:     total}

  defstruct basket:    nil,
            discounts: [],
            total:     0

  @spec new(basket) :: t
  def new(%Basket{} = basket) do
    total = basket
            |> Basket.products
            |> Enum.reduce(0, &(&2 + &1.price))

    %Bill{basket: basket, total: total}
  end

  @spec apply(t, discount) :: t
  def apply(%Bill{discounts: discounts, total: total} = bill,
            %Discount{amount: amount} = discount) do
    new_discounts = [discount | discounts]
    new_total     = total - amount

    %{bill | discounts: new_discounts, total: new_total}
  end

  @spec products(t) :: [product]
  def products(%Bill{basket: basket}) do
    Basket.products(basket)
  end

  @spec discounts(t) :: [discount]
  def discounts(%Bill{discounts: discounts}) do
    Enum.reverse(discounts)
  end
end
