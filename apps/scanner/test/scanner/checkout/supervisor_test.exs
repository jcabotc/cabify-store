defmodule Scanner.Checkout.SupervisorTest do
  use ExUnit.Case, async: true

  alias Scanner.Checkout

  defmodule TestCheckout do
    def start_link(rules),
      do: Agent.start_link(fn -> rules end)

    def get(agent),
      do: Agent.get(agent, &(&1))
  end

  @name :scanner_checkout_supervisor_test_sup_name

  test "start_link/2 and start_checkout/1" do
    rules = :fake_rules
    opts  = [checkout: TestCheckout, name: @name]

    {:ok, sup} = Checkout.Supervisor.start_link(rules, opts)

    {:ok, pid_1} = Checkout.Supervisor.start_checkout(sup)
    assert rules == TestCheckout.get(pid_1)

    {:ok, pid_2} = Checkout.Supervisor.start_checkout(sup)
    assert rules == TestCheckout.get(pid_2)

    assert pid_1 != pid_2
  end
end
