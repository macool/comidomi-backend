class CustomerAddressPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        customer_profile_id: user.customer_profile.id
      )
    end
  end

  def permitted_attributes
    [
      :lat,
      :lon,
      :nombre,
      :ciudad,
      :parroquia,
      :barrio,
      :direccion_uno,
      :direccion_dos,
      :codigo_postal,
      :referencia,
      :numero_convencional
    ]
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

  private

  def is_customer?
    user.customer_profile.present?
  end
end
