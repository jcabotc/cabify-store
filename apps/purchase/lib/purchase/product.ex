defmodule Purchase.Product do
  alias __MODULE__

  @type id    :: atom
  @type name  :: String.t
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
