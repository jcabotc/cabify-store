# Store

Implementation of [this code challenge](https://gist.github.com/patriciagao/377dca8920ba3b1fc8da).

## Core decisions

### Money representation

Any amount of money throughout the code is represented in cents as an integer. The reasons are:

  * **Float arithmetic**: To prevent [losing small amounts](http://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency) after many operations
  * **Complete value space**: Every possible integer amount of cents represents a payable amount of money (float `7.2512€` is not payable with coins and notes)

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
