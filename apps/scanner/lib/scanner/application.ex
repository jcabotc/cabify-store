defmodule Scanner.Application do
  @moduledoc false

  use Application

  alias Scanner.Checkout

  @rules Purchase.Rules.parse!()

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Checkout.Supervisor, [@rules])
    ]

    opts = [strategy: :one_for_one, name: Scanner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
