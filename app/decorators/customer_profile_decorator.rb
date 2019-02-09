class CustomerProfileDecorator < GenericResourceDecorator
  decorates_association :user

  def to_s
    user.to_s
  end
end
