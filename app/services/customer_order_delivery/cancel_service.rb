class CustomerOrderDelivery < ActiveRecord::Base
  class CancelService
    def initialize(customer_order_delivery)
      @customer_order_delivery = customer_order_delivery
    end

    def perform
      if can_cancel?
        cancel!
      else
        add_errors
        false
      end
    end

    private

    def cancel!
      @customer_order_delivery.update!(
        status: :canceled
      )
    end

    def add_errors
      @customer_order_delivery.errors.add(
        :base,
        :cant_cancel_old_delivery
      )
    end

    def can_cancel?
      responded_at = @customer_order_delivery.provider_responded_at
      responded_at.blank? || inside_range?(responded_at)
    end

    def inside_range?(responded_at)
      (Time.now - responded_at) < 5.minutes
    end
  end
end
