defprotocol Purchase.Promotion do
  @moduledoc "A protocol to be implemented by all promotions."

  @type bill :: Purchase.Bill.t

  @doc "Applies 0 or more discounts of the given promotion to a bill"
  @spec apply(t, bill) :: bill
  def apply(promotion, bill)
end
