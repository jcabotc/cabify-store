defmodule Checkout.Discount do
  alias __MODULE__

  @type name   :: String.t
  @type amount :: number

  @type t :: %__MODULE__{name:   name,
                         amount: amount}

  defstruct [:name, :amount]

  @type attributes :: [name:   name,
                       amount: amount]

  @spec new(attributes) :: t
  def new(attributes) when is_list(attributes) do
    name   = Keyword.fetch!(attributes, :name)
    amount = Keyword.fetch!(attributes, :amount)

    %Discount{name: name, amount: amount}
  end
end
