class CustomerBillingAddressPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        customer_profile_id: user.customer_profile.id
      )
    end
  end

  def index?
    true
  end

  def create?
    is_customer?
  end

  def update?
    is_customer?
  end

  def permitted_attributes
    [
      :ruc,
      :email,
      :ciudad,
      :telefono,
      :direccion,
      :razon_social
    ]
  end

  private

  def is_customer?
    user.customer_profile.present?
  end
end
