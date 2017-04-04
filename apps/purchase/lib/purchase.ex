defmodule Purchase do
  @moduledoc """
  The `Purchase` struct represents a purchasing process.

  To start a purchasing process the pricing rules must be provided.
  (`Purchase.Rules` for more information)
  After that we can add products, and retrieve the bill.

  ```elixir
  rules = Purchase.Rules.parse!()

  purchase = Purchase.new(rules)

  {:ok, purchase} = Purchase.add(purchase, :foo)
  {:ok, purchase} = Purchase.add(purchase, :foo)
  {:ok, purchase} = Purchase.add(purchase, :bar)

  Purchase.bill(purchase) # => %Purchase.Bill{...}
  ```
  """

  alias Purchase.{Rules, Product, Basket, Promotion, Bill}

  @type rules      :: Rules.t
  @type product    :: Product.t
  @type product_id :: Product.id
  @type basket     :: Basket.t
  @type bill       :: Bill.t

  @type t :: %__MODULE__{rules:  rules,
                         basket: basket}

  defstruct rules:  nil,
            basket: Basket.new

  @spec new(rules) :: t
  def new(%Rules{} = rules) do
    %Purchase{rules: rules}
  end

  @spec add(t, product_id) :: {:ok, product} | {:error, reason :: term}
  def add(%Purchase{rules: rules, basket: basket} = purchase, product_id) do
    case Rules.product(rules, product_id) do
      {:ok, product} ->
        new_basket = Basket.add(basket, product)
        {:ok ,%{purchase | basket: new_basket}}

      :unknown ->
        {:error, {:unknown_product_id, product_id}}
    end
  end

  @spec bill(t) :: bill
  def bill(%Purchase{rules: rules, basket: basket}) do
    rules.promotions
    |> Enum.reduce(Bill.new(basket), &Promotion.apply/2)
  end
end
