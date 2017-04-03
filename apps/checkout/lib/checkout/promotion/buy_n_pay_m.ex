defmodule Checkout.Promotion.BuyNPayM do
  alias __MODULE__
  alias Checkout.Product

  @type name           :: String.t
  @type product        :: Product.t
  @type batch_size     :: pos_integer
  @type free_per_batch :: non_neg_integer

  @type t :: %__MODULE__{name:           name,
                         product:        product,
                         batch_size:     batch_size,
                         free_per_batch: free_per_batch}

  defstruct [:name, :product, :batch_size, :free_per_batch]

  @behaviour Checkout.Rules.Parser.Promotion
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

defimpl Checkout.Promotion, for: Checkout.Promotion.BuyNPayM do
  alias Checkout.{Discount, Bill}

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
