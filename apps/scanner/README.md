# Scanner

A physical store that uses a code scanner to identify products.

## Hello world

```elixir
{:ok, checkout} = Checkout.Supervisor.start_checkout()

:ok = Checkout.scan(checkout, "VOUCHER")
:ok = Checkout.scan(checkout, "VOUCHER")
:ok = Checkout.scan(checkout, "TSHIRT")

Checkout.total(checkout) # => 3000 (total in cents)
Checkout.finish(checkout)
```

## Introduction

In the code challenge there is not enough information to complete this application.
I have implemented some basic functionality to show how to use the `Purchase` application
to manage a physical store that uses a scanner to identify its products.

## Internals

This application provides a parser that is able to convert scanned codes to product ids
and uses the `Purchase` application to manage the checkout process.

It also provides a simple supervision tree built of a `simple_one_for_one` supervisor
whose childs are `Scanner.Checkout` workers.
Each worker manages a purchasing process for one customer.

### Parser

The `Scanner.Parser` is the module that translates scanned codes to product ids.

```elixir
correspondence = %{"FOO" => :foo,
                   "BAR" => :bar}

Scanner.Parser.parse("BAR", correspondence) # => :bar
```

By default it gets the correspondence map from `Mix.Config`.
The following is the same as above:

```elixir
# in config/config.exs
use Mix.Config

config :scanner, :codes, %{"FOO" => :foo,
                           "BAR" => :bar}

# anywhere else
Scanner.Parser.parse("BAR") # => :bar
```

### Checkout

The `Scanner.Checkout` module implements a `GenServer` that keeps the state
of a purchasing process.

```elixir
rules = Purchase.Rules.parse!()

# start a new checkout process with the given rules
{:ok, checkout} = Checkout.start_link(rules)

# scan some product codes
:ok = Checkout.scan("FOO")
:ok = Checkout.scan("BAR")

# scan an unknown product code
{:error, _reason} = Checkout.scan("UNKNOWN")

Checkout.total(checkout) # => total amount in cents

# stop the process
Checkout.finish(checkout)
```

This module is a very simple implementation of a checkout process
to demonstrate how to use the `Purchase` application to manage a physical store.
In a real production environment some more actions should take place:

  * Return the complete bill in order to print it instead of just the total value
  * Persist the fact that a checkout has taken place to keep a record of purchases on `finish/1`
  * Allow to cancel a checkout when it has not been completed without persisting

### Checkout supervisor and the Application

As said before, there is not enough information on the code challenge to know if this implementation
is needed.

I implemented a `simple_one_for_one` supervisor to demonstrate how to start new checkout processes
with the same rules that are parsed in compilation time.

```elixir
# starts a checkout process with rules from configuration
{:ok, checkout} = Scanner.Checkout.Supervisor.start_checkout()
```
