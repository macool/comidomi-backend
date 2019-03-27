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

  def permitted_attributes
    [ :description ]
  end
end
