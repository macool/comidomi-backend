class CustomerOrderDeliveryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        customer_order_id: user.customer_profile.current_order
      )
    end
  end

  def update?
    order_in_progress?
  end

  def permitted_attributes
    [
      :id,
      :delivery_method,
      :customer_address_id,
      :provider_profile_id,
      :deliver_at
    ]
  end

  def cancel?
    record.status.pending? || record.status.accepted?
  end

  private

  def order_in_progress?
    user.customer_profile.current_order.present?
  end
end
