defprotocol Purchase.Promotion do
  @type bill :: Purchase.Bill.t

  @spec apply(t, bill) :: bill
  def apply(promotion, bill)
end
