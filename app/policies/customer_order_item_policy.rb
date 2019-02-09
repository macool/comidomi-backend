class CustomerOrderItemPolicy < ApplicationPolicy
  ##
  # scope is not being used.
  # controllers access via #current_order
  # class Scope < Scope
  #   def resolve
  #     scope.where(
  #       customer_order_id: user.customer_profile.customer_orders.pluck(:id)
  #     )
  #   end
  # end

  def permitted_attributes
    [
      :cantidad,
      :observaciones,
      :provider_item_id
    ]
  end

  def index?
    true
  end

  def create?
    is_customer?
  end

  def update?
    order_in_progress?
  end

  def destroy?
    order_in_progress?
  end

  private

  def is_customer?
    user.customer_profile.present?
  end

  def order_in_progress?
    # all users can edit their own
    # order items within their order
    # in progress.
    # scope should be
    # provided by the class or this
    # method should verify the order's
    # ownership otherwise
    record.customer_order.status.in_progress?
  end
end
