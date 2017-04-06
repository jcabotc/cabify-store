# Purchase

An implementation of the purchasing process of a store.

## Hello world

```elixir
rules = Purchase.Rules.parse!([
          products: [
            foo: [name: "Foo", price: 1000],
            bar: [name: "Bar", price: 2000]],
          promotions: [
            {Purchase.Promotion.BuyNPayM, name:       "3 for 2 in Foo",
                                          product_id: :foo,
                                          buy:        3,
                                          pay:        2}]])

purchase = Purchase.new(rules)

{:ok, purchase} = Purchase.add(purchase, :foo)
{:ok, purchase} = Purchase.add(purchase, :foo)
{:ok, purchase} = Purchase.add(purchase, :foo)
{:ok, purchase} = Purchase.add(purchase, :bar)

bill = Purchase.bill(purchase) # => %Purchase.Bill{...}
bill.total                     # => 4000
```

In the example above we are declaring the following rules:

  * There are 2 products: Foo and Bar
  * Buying 3 Foos you only pay for 2 of them

Using those rules we start a new purchase process, and we add 4
products: 3 foos and 1 bar

Then we generate a bill for that process that contains the total
price.

## Internals

The implementation of `Purchase` is purely funcional, as there are no
side effects.

(The only exception is the `Purchase.Rules.parse!/0` function that
gets configuration from `Mix.Config`. More information on the Rules section)

### Product and Basket

The `Purchase.Product` model represents a buyable product. It has 3 fields:

  * `:id` - A unique identifier
  * `:name` - A name to be read by humans
  * `:price` - The price of the product in cents

```elixir
product = Purchase.Product.new(:foo, name: "Foo", price: 1000)

product.id    # => :foo
product.name  # => "Foo"
product.price # => 1000
```

The reason of using a keyword list to set the attributes is to
be able to add new attributes in the future without modifying the
function interface and to remove the need to remember the order
of the arguments.

A `Purchase.Basket` represents a collection of products.

```elixir
alias Purchase.{Product, Basket}

product_1 = Product.new(:foo, name: "Foo", price: 1000)
product_2 = Product.new(:bar, name: "Bar", price: 2000)

basket = Basket.new
         |> Basket.add(product_1)
         |> Basket.add(product_2)
         |> Basket.add(product_2)

Basket.products(basket) # => [product_1, product_2, product_2]
```

Pattern matching may be used to get the products from a basket,
but `products/1` returns the products in the same order they were
introduced (this may be useful for presentational use cases like
printing a bill).

### Discount

The `Purchase.Discount` model represents a discount to be applied to the purchase.
It has 2 fields:

  * `:name` - A name to be read by humans describing the discount
  * `:amount` - The amount of the discount in cents

```elixir
discount = Purchase.Discount.new(name: "2 for 1 in Foo", amount: 1000)

discount.name  # => "2 for 1 in Foo"
discount.price # => 1000
```

The reason of using a keyword list to set the attributes is to
be able to add new attributes in the future without modifying the
function interface and to remove the need to remember the order of the
arguments.

### Bill

A `Purchase.Bill` is the outcome of a purchase. It holds a basket and applies
discounts to it. It has 3 fields:

  * `:basket` - A basket of products to purchase
  * `:discounts` - A collection of applied discounts
  * `:total` - The total price in cents

```elixir
alias Purchase.{Product, Basket, Discount, Bill}

product = Product.new(:foo, name: "Foo", price: 1000)
discount = Discount.new(name: "Some discount", amount: 500)

basket = Basket.new
         |> Basket.add(product)
         |> Basket.add(product)

bill = Bill.new(basket)
bill.total # => 2000

bill = Bill.apply(bill, discount)
bill.total # => 1500

bill = Bill.apply(bill, discount)
bill.total # => 1000

Bill.products(bill)  # => [product, product]
Bill.discounts(bill) # => [discount, discount]
```

The `:total` attribute is always consistent with the basket and the
applied discounts.

### The Promotion protocol

The `Purchase.Promotion` protocol requires the implementation of the
function `apply/2` that receives the promotion to be applied and a bill,
and should return a bill with 0 or more discounts applied.

Promotions may be very different from one to another, both on its behaviour
and configuration, and therefore many implementations may be required.
A protocol is a very simple and elegant way of achieving polymorphism in such
situations.

Adding a new promotion does not require any modification of the existing code,
it only requires the definition of a new module that implements the protocol.

```elixir
defmodule UnconditionalDiscount do
  defstruct [:amount]
end

defimpl Purchase.Protocol, for: UnconditionalDiscount do
  alias Purchase.{Discount, Bill}

  def apply(%{amount: amount}, %Bill{} = bill) do
    discount = Discount.new(name: "Unconditional", amount: amount)

    Bill.apply(bill, discount)
  end
end
```

The above example implements a very simple promotion that applies a discount
unconditionally:

```elixir
alias Purchase.{Product, Basket, Bill, Promotion}

product = Product.new(:foo, name: "Foo", price: 1000)

bill = Basket.new
       |> Basket.add(product)
       |> Bill.new
bill.total # => 1000

promotion = %UnconditionalDiscount{amount: 500}

bill = Promotion.apply(promotion, bill)
bill.total # => 500
```

### Built-in promotions

Due to the requirements of the code challenge, only 2 implementations are built-in:

#### BuyNPayM

For every batch of N products contained in the basket, only M products are paid.

```elixir
alias Purchase.{Product, Basket, Bill, Promotion}

product = Product.new(:foo, name: "Foo", price: 1000)

bill = Basket.new
       |> Basket.add(product)
       |> Basket.add(product)
       |> Basket.add(product)
       |> Basket.add(product)
       |> Basket.add(product)
       |> Bill.new
bill.total # => 5000

promotion = Promotion.BuyNPayM.new("2 for 1 on Foo", # name
                                   product,          # product
                                   2,                # batch size (N)
                                   1)                # free per batch (N - M)

bill = Promotion.apply(promotion, bill)
bill.total # => 3000
```

To simplify promotion declaration, the `BuyNPayM` promotion implements
the `Purchase.Rules.Parser.Protocol` behaviour (more on the Rules section).

The following declaration is the same as before:

```elixir
alias Purchase.{Product, Promotion}

product  = Product.new(:foo, name: "Foo", price: 1000)
products = [product]

config = [name:       "2 for 1 on Foo",
          product_id: :foo,
          buy:        2,
          pay:        1]

promotion = Promotion.BuyNPayM.parse(config, products)
```

#### BulkDiscount

If you buy more than N products, the price per unit is cheaper.

```elixir
alias Purchase.{Product, Basket, Bill, Promotion}

product = Product.new(:foo, name: "Foo", price: 1000)

bill = Basket.new
       |> Basket.add(product)
       |> Basket.add(product)
       |> Basket.add(product)
       |> Bill.new
bill.total # => 3000

promotion = Promotion.BulkDiscount.new("Buy 2 or more Foo: 8€", # name
                                       product,                 # product
                                       2,                       # quantity
                                       200)                     # discount per unit

bill = Promotion.apply(promotion, bill)
bill.total # => 2400
```

To simplify promotion declaration, the `BulkDiscount` promotion implements
the `Purchase.Rules.Parser.Protocol` behaviour (more on the Rules section).

The following declaration is the same as before:

```elixir
alias Purchase.{Product, Promotion}

product  = Product.new(:foo, name: "Foo", price: 1000)
products = [product]

config = [name:       "Buy 2 or more Foo: 8€",
          product_id: :foo,
          quantity:   2,
          bulk_price: 800]

promotion = Promotion.BulkDiscount.parse(config, products)
```

### Rules

The `Purchase.Rules` struct defines the available products and the active promotions.

```elixir
alias Purchase.{Product, Promotion, Rules}

product_1 = Product.new(:foo, name: "Foo", price: 1000)
product_2 = Product.new(:bar, name: "Bar", price: 2000)
products  = [product_1, product_2]

promotion_1 = Promotion.BuyNPayM.new("2 for 1 Foo", product, 2, 1)
promotion_2 = Promotion.BulkDiscount.new("2+ Foo: 8€", product_1, 2, 200)
promotions  = [promotion_1, promotion_2]

rules = Rules.new(products, promotions)
rules.products   # => products
rules.promotions # => promotions

Rules.product(rules, :foo) # => {:ok, product_1}
Rules.product(rules, :bar) # => {:ok, product_2}
Rules.product(rules, :baz) # => :unknown
```

As seen above `product/2` allows to fetch products by its id.

#### Parsing the rules

To simplify the definition of the rules, the `Purchase.Rules` module responds to
`parse!/1` to build the rules from configuration.

The following rules definition is the same as in the previous example:

```elixir
alias Purchase.{Rules, Promotion}

rules = Rules.parse!([
          products: [
            foo: [name: "Foo", price: 1000],
            bar: [name: "Bar", price: 2000]],
          promotions: [
            {Promotion.BuyNPayM, name:       "2 for 1 Foo",
                                 product_id: :foo,
                                 buy:        2,
                                 pay:        1},
            {Promotion.BulkDiscount, name:       "2+ Foo: 8€",
                                     product_id: :foo,
                                     quantity:   2,
                                     pay:        1}]])
```

The reason for the exclamation mark in the end is that it will raise an error
on invalid configuration. When possible it is recommended to parse the rules in
compilation time to ensure they are properly formatted.

An unlimited number of promotions is allowed, and therefore `Purchase.Rules` cannot
hold the knowledge of how to parse and build every possible promotion.
To solve this issue it defines the behaviour `Purchase.Rules.Parser.Promotion` that
requires the implementation of `parse/2`. It receives the configuration as first argument
(the keyword list following the name of the promotion module) and the list of available
products as the second argument.

All protocols that have to be declared from configuration as seen above should
implement that behaviour.

As many applications may declare the rules configuration using `Mix.Config`
a `parse!/0` function is provided that takes the configuration from the environment.
The following examples return the same rules:

```elixir
rules_1 = Purchase.Rules.parse!()

rules_config = Application.get_env(:purchase, :rules)
rules_2 = Purchase.Rules.parse!(rules_config)

rules_1 == rules_2 # => true
```

### Purchase

The final piece of the application is the `Purchase` module. It represents a purchasing
process:

```elixir
rules = Purchase.Rules.parse!

purchase = Purchase.new(rules)

{:ok, purchase} = Purchase.add(purchase, :foo)
{:ok, purchase} = Purchase.add(purchase, :foo)
{:ok, purchase} = Purchase.add(purchase, :bar)

Purchase.add(purchase, :baz) # => {:error, {:unknown_product_id, :baz}}

bill = Purchase.bill(purchase)
bill.total # => total price in cents
```

In the example above a `Purchase` is created with rules from mix configuration,
then we add 3 products to the purchase using its ids.
After that the bill is generated.

The reason the `add/2` function returns `{:ok, purchase}` or `{:error, reason}` is that
is most cases, during the purchasing process, it is necessary to known inmediately whether
the addition of a product succeeded.
For instance, in a physical shop, when a product cannot be scanned it has to be notified
inmediately without crashing to allow the shop assistant to solve the problem and retry or
remove that product and continue with the rest of the products.

As seen in previous sections, the generated bill includes the list of purchased products (the basket),
the list of applied discounts, and the total price in cents.
