defmodule Checkout.Promotion.BulkDiscount do
  alias __MODULE__
  alias Checkout.Product

  @type name              :: String.t
  @type product           :: Product.t
  @type quantity          :: non_neg_integer
  @type discount_per_unit :: number

  @type t :: %__MODULE__{name:              name,
                         product:           product,
                         quantity:          quantity,
                         discount_per_unit: discount_per_unit}

  defstruct [:name, :product, :quantity, :discount_per_unit]

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
