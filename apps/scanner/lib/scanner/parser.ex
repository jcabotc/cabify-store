defmodule Scanner.Parser do
  @correspondence Application.get_env(:scanner, :codes)

  def parse(code, correspondence \\ @correspondence) do
    case Map.fetch(correspondence, code) do
      {:ok, product_id} -> {:ok, product_id}
      :error            -> {:error, {:unknown_code, code}}
    end
  end
end
