defmodule Scanner.Integration.ChallengeExamplesTest do
  use ExUnit.Case, async: true

  alias Scanner.Checkout

  @rules Purchase.Rules.parse!()

  test "first example" do
    {:ok, checkout} = Checkout.start_link(@rules)

    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "MUG")

    assert 3250 == Checkout.total(checkout)
  end

  test "second example" do
    {:ok, checkout} = Checkout.start_link(@rules)

    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "VOUCHER")

    assert 2500 == Checkout.total(checkout)
  end

  test "third example" do
    {:ok, checkout} = Checkout.start_link(@rules)

    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "TSHIRT")
    assert :ok == Checkout.scan(checkout, "VOUCHER")
    assert :ok == Checkout.scan(checkout, "TSHIRT")

    assert 8100 == Checkout.total(checkout)
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

    assert 7450 == Checkout.total(checkout)
  end
end
