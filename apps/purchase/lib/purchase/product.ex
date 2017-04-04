defmodule Purchase.Product do
  @moduledoc "A model that represents a purchaseable product"

  alias __MODULE__

  @typedoc "Unique identifier"
  @type id :: atom

  @typedoc "Human-readable name"
  @type name :: String.t

  @typedoc "Price in cents"
  @type price :: integer

  @type t :: %__MODULE__{id:    id,
                         name:  name,
                         price: price}

  defstruct [:id, :name, :price]

  @type attributes :: [name:  name,
                       price: price]

  @spec new(id, attributes) :: t
  def new(id, attributes)
  when is_atom(id) and is_list(attributes) do
    name  = Keyword.fetch!(attributes, :name)
    price = Keyword.fetch!(attributes, :price)

    %Product{id: id, name: name, price: price}
  end
end
