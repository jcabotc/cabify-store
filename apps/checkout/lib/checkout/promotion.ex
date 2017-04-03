defprotocol Checkout.Promotion do
  @type bill :: Checkout.Bill.t

  @spec apply(t, bill) :: bill
  def apply(promotion, bill)
end
