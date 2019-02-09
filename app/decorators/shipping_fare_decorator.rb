class ShippingFareDecorator < GenericResourceDecorator
  def to_s
    h.humanized_money_with_symbol object.price
  end
end
