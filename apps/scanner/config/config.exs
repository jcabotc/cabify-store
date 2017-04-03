use Mix.Config

alias Purchase.Promotion.{BuyNPayM, BulkDiscount}

config :purchase, :rules,
  products: [
    voucher: [name: "Cabify Voucher",    price: 5.0],
    tshirt:  [name: "Cabify T-Shirt",    price: 20.0],
    mug:     [name: "Cabify Coffee Mug", price: 7.5]],
  promotions: [
    {BuyNPayM, name:       "2-for-1 on vouchers",
               product_id: :voucher,
               buy:        2,
               pay:        1},
    {BulkDiscount, name:       "3 or more T-shirts for 19€ per unit ",
                   product_id: :tshirt,
                   quantity:   3,
                   bulk_price: 19.0}]

config :scanner, :codes, %{
  "VOUCHER" => :voucher,
  "TSHIRT"  => :tshirt,
  "MUG"     => :mug
}
