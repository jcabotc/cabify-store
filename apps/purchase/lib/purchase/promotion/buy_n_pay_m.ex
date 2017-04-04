defmodule Purchase.Promotion.BuyNPayM do
  @moduledoc """
  A promotion that, for every batch of N units of the same product
  in the basket, applies a discount so that the customer only has
  to pay for M of them.
  """

  alias __MODULE__
  alias Purchase.Product

  @typedoc "A human-readable description of the discount"
  @type name :: String.t

  @typedoc "The product to apply the discount to"
  @type product :: Product.t

  @typedoc "The size of the batch (N)"
  @type batch_size :: pos_integer

  @typedoc "The number of free units per batch (N - M)"
  @type free_per_batch :: non_neg_integer

  @type t :: %__MODULE__{name:           name,
                         product:        product,
                         batch_size:     batch_size,
                         free_per_batch: free_per_batch}

  defstruct [:name, :product, :batch_size, :free_per_batch]

  @behaviour Purchase.Rules.Parser.Promotion
  defdelegate parse(config, products), to: BuyNPayM.Parser

  @spec new(name, product, batch_size, free_per_batch) :: t
  def new(name, %Product{} = product, batch_size, free_per_batch)
  when is_binary(name)
  and is_integer(batch_size) and batch_size > 0
  and is_integer(free_per_batch) and free_per_batch >= 0 do
    %BuyNPayM{name:           name,
              product:        product,
              batch_size:     batch_size,
              free_per_batch: free_per_batch}
  end
end

defimpl Purchase.Promotion, for: Purchase.Promotion.BuyNPayM do
  alias Purchase.{Discount, Bill}

  def apply(promotion, %Bill{} = bill) do
    bill
    |> Bill.products
    |> free_units(promotion)
    |> discount(bill, promotion)
  end

  defp free_units(products, %{product: target_product} = promotion) do
    products
    |> Enum.count(&(&1 == target_product))
    |> Kernel.div(promotion.batch_size)
    |> Kernel.*(promotion.free_per_batch)
  end

  defp discount(0, bill, _promotion) do
    bill
  end
  defp discount(units, bill, %{name: name, product: product}) do
    amount   = product.price * units
    discount = Discount.new(name: name, amount: amount)

    Bill.apply(bill, discount)
  end
end
