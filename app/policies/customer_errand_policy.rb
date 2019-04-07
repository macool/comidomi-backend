class CustomerErrandPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        customer_profile_id: user.customer_profile.id
      )
    end
  end

  def create?
    user.customer_profile.present?
  end

  def show?
    user.customer_profile.present?
  end

  def permitted_attributes
    [ :description, :customer_address_id ]
  end
end
