defmodule Purchase.Discount do
  @moduledoc "A model that represents a discount"

  alias __MODULE__

  @typedoc "Human-readable description"
  @type name :: String.t

  @typedoc "Amount to subtract in cents"
  @type amount :: integer

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
