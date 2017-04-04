defmodule Purchase.Bill do
  @moduledoc """
  A `Purchase.Bill` struct holds a basket of products to purchase,
  a collection of discounts applied, and the always updated total
  amount in cents.
  """

  alias __MODULE__
  alias Purchase.{Basket, Discount}

  @type basket   :: Basket.t
  @type product  :: Product.t
  @type discount :: Discount.t

  @typedoc "Total amount in cents with the discounts applied"
  @type total :: integer

  @type t :: %__MODULE__{basket:    basket,
                         discounts: [discount],
                         total:     total}

  defstruct basket:    nil,
            discounts: [],
            total:     0

  @doc "Create a new bill and calculate total price of the basket"
  @spec new(basket) :: t
  def new(%Basket{} = basket) do
    total = basket
            |> Basket.products
            |> Enum.reduce(0, &(&2 + &1.price))

    %Bill{basket: basket, total: total}
  end

  @doc "Add a discount and subtract it from the total amount"
  @spec apply(t, discount) :: t
  def apply(%Bill{discounts: discounts, total: total} = bill,
            %Discount{amount: amount} = discount) do
    new_discounts = [discount | discounts]
    new_total     = total - amount

    %{bill | discounts: new_discounts, total: new_total}
  end

  @doc "All products in the order they were added"
  @spec products(t) :: [product]
  def products(%Bill{basket: basket}) do
    Basket.products(basket)
  end

  @doc "All discount in the order they were applied"
  @spec discounts(t) :: [discount]
  def discounts(%Bill{discounts: discounts}) do
    Enum.reverse(discounts)
  end
end
