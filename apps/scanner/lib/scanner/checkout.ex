defmodule Scanner.Checkout do
  use GenServer

  @parser &Scanner.Parser.parse/1

  def start_link(rules, opts \\ []) do
    {parser, opts} = Keyword.pop(opts, :parser, @parser)

    GenServer.start_link(__MODULE__, {rules, parser}, opts)
  end

  def scan(checkout, code) when is_binary(code),
    do: GenServer.call(checkout, {:scan, code})

  def total(checkout),
    do: GenServer.call(checkout, :total)

  def finish(checkout),
    do: GenServer.stop(checkout)

  def init({rules, parser}) do
    purchase = Purchase.new(rules)

    {:ok, %{purchase: purchase, parser: parser}}
  end

  def handle_call({:scan, code}, _from, %{purchase: purchase, parser: parser} = state) do
    with {:ok, product_id}   <- parser.(code),
         {:ok, new_purchase} <- Purchase.add(purchase, product_id) do
      {:reply, :ok, %{state | purchase: new_purchase}}
    else
      {:error, _reason} = error -> {:reply, error, state}
    end
  end
  def handle_call(:total, _from, %{purchase: purchase} = state) do
    %{total: total} = Purchase.bill(purchase)

    {:reply, total, state}
  end
end
