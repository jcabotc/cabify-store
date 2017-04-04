defmodule Scanner.Checkout.Supervisor do
  use Supervisor

  @checkout_mod Scanner.Checkout
  @name __MODULE__

  def start_link(rules, opts \\ []) do
    {checkout_mod, opts} = Keyword.pop(opts, :checkout, @checkout_mod)
    opts = Keyword.put_new(opts, :name, @name)

    Supervisor.start_link(__MODULE__, {rules, checkout_mod}, opts)
  end

  def start_checkout(sup \\ @name) do
    Supervisor.start_child(sup, [])
  end

  def init({rules, checkout_mod}) do
    children = [
      worker(checkout_mod, [rules], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
