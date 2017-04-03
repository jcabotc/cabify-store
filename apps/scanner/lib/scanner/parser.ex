defmodule Scanner.Parser do
  @correspondence Application.get_env(:scanner, :codes, %{})

  @type code           :: binary
  @type product_id     :: Purchase.Product.id
  @type correspondence :: %{code => product_id}

  @spec parse(code, correspondence) :: {:ok, product_id} | {:error, reason :: term}
  def parse(code, correspondence \\ @correspondence) do
    case Map.fetch(correspondence, code) do
      {:ok, product_id} -> {:ok, product_id}
      :error            -> {:error, {:unknown_code, code}}
    end
  end
end
