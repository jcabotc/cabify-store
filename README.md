# Store

Implementation of [this code challenge](https://gist.github.com/patriciagao/377dca8920ba3b1fc8da).

## Core decisions

### Money representation

Any amount of money throughout the code is represented in cents as an integer. The reasons are:

  * **Float arithmetic**: To prevent [losing small amounts](http://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency) after many operations
  * **Complete value space**: Every possible integer amount of cents represents a payable amount of money (float `7.2512€` is not payable with coins and notes)

The prices of the products when configuring the rules must be also provided in cents. If this was an issue the
`Rules.Parser` could take care of it.

The total price of the checkout process is also given in cents, I think is not the responsability of this code
to transform it into a float. It should be the presentational layer who converts it from an integer to any format
it needs.

### Umbrella project

The behaviour needed to implement the challenge can be divided in two parts that have been implemented as
two different OTP applications:

  * `Purchase`: Represents an abstract purchasing process (not dependent on the type of shop). Has knowledge about
  how to add products to a basket, apply discounts, and calculate the total price.

  * `Scanner`: Represents a physical shop that uses a scanner to identify products. Has knowledge about the relation
  between scanned codes and actual products.

If Cabify decides to open an online web store, or a cashier-free store that uses computer vision and sensors to identify
what products the customer took (like the one Amazon just launched), the `Purchase` logic would require no modification.

The `Scanner` application depends on `Purchase`. It acts as an interface between the code scanner and the purchasing process.

### Examples in the code challenge

The configuration of the `Scanner` application (for all environments) at `apps/scanner/config/config.exs` is
the same as the one in the code challenge.

To reproduce the checkout process shown in the code challenge to show the interface
start iex session with `iex -S mix`:

```elixir
Interactive Elixir (1.4.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> alias Scanner.Checkout
Scanner.Checkout
iex(2)> pricing_rules = Purchase.Rules.parse!()
%Purchase.Rules{...}
iex(3)> {:ok, co} = Checkout.start_link(pricing_rules)
{:ok, #PID<0.180.0>}
iex(4)> Checkout.scan(co, "VOUCHER")
:ok
iex(5)> Checkout.scan(co, "VOUCHER")
:ok
iex(6)> Checkout.scan(co, "TSHIRT")
:ok
iex(7)> price = Checkout.total(co)
2500
```

The 4 examples given in the code challenge are executed in this test at: `apps/scanner/test/integration/challenge_examples_test.exs`


