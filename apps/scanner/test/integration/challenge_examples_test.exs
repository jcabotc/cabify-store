defmodule Scanner.Integration.ChallengeExamplesTest do
  use ExUnit.Case, async: true

  alias Scanner.Checkout

  @rules Purchase.Rules.parse!()

  test "first example" do
    {:ok, checkout} = Checkout.start_link(@rules)

    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "MUG")

    assert 32.5 == Checkout.total(checkout)
  end

  test "second example" do
    {:ok, checkout} = Checkout.start_link(@rules)

    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "VOUCHER")

    assert 25.0 == Checkout.total(checkout)
  end

  test "third example" do
    {:ok, checkout} = Checkout.start_link(@rules)

    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "TSHIRT")

    assert 81.0 == Checkout.total(checkout)
  end

  test "fourth example" do
    {:ok, checkout} = Checkout.start_link(@rules)

    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "MUG")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "TSHIRT")

    assert 74.5 == Checkout.total(checkout)
  end
end
