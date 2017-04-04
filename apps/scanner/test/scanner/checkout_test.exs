defmodule Scanner.CheckoutTest do
  use ExUnit.Case, async: true

  alias Scanner.Checkout

  @raw_rules [
    products: [
      foo: [name: "foo", price: 1000],
      bar: [name: "bar", price: 1500]],
    promotions: []]

  test "scan/2 and total/1" do
    rules = Purchase.Rules.parse!(@raw_rules)

    parser = fn
      "FOO" -> {:ok, :foo}
      "BAR" -> {:ok, :bar}
      _any  -> {:error, :some_reason}
    end

    {:ok, checkout} = Checkout.start_link(rules, parser: parser)

    assert {:error, :some_reason} = Checkout.scan(checkout, "BAZ")

    assert :ok = Checkout.scan(checkout, "FOO")
    assert :ok = Checkout.scan(checkout, "BAR")

    assert 2500 == Checkout.total(checkout)

    ref = Process.monitor(checkout)
    Process.unlink(checkout)

    assert :ok == Checkout.finish(checkout)
    assert_receive {:DOWN, ^ref, :process, ^checkout, :normal}
  end
end
