defmodule Purchase.Promotion.BulkDiscount do
  alias __MODULE__
  alias Purchase.Product

  @type name              :: String.t
  @type product           :: Product.t
  @type quantity          :: non_neg_integer
  @type discount_per_unit :: number

  @type t :: %__MODULE__{name:              name,
                         product:           product,
                         quantity:          quantity,
                         discount_per_unit: discount_per_unit}

  defstruct [:name, :product, :quantity, :discount_per_unit]

  @behaviour Purchase.Rules.Parser.Promotion
  defdelegate parse(config, products), to: BulkDiscount.Parser

  @spec new(name, product, quantity, discount_per_unit) :: t
  def new(name, %Product{} = product, quantity, discount_per_unit)
  when is_binary(name)
  and is_integer(quantity) and quantity >= 0
  and is_number(discount_per_unit) do
    %BulkDiscount{name:              name,
                  product:           product,
                  quantity:          quantity,
                  discount_per_unit: discount_per_unit}
  end
end

defimpl Purchase.Promotion, for: Purchase.Promotion.BulkDiscount do
  alias Purchase.{Discount, Bill}

  def apply(promotion, %Bill{} = bill) do
    bill
    |> Bill.products
    |> occurrences(promotion.product)
    |> discount(bill, promotion)
  end

  defp occurrences(products, target_product) do
    Enum.count(products, &(&1 == target_product))
  end

  defp discount(occurrences, bill, %{quantity: quantity})
  when occurrences < quantity do
    bill
  end
  defp discount(occurrences, bill, %{name: name, discount_per_unit: discount_per_unit}) do
    amount   = occurrences * discount_per_unit
    discount = Discount.new(name: name, amount: amount)

    Bill.apply(bill, discount)
  end
end
