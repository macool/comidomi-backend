class CustomerOrderDelivery < ActiveRecord::Base
  class DispatchAtCalculatorService
    attr_reader :delivery

    def initialize(customer_order_delivery)
      @delivery = customer_order_delivery
    end

    def dispatch_at
      if calculate_dispatch_at?
        if delivery.deliver_at.present? && can_dispatch_for_future?
          delivery.deliver_at
        else
          delivery.provider_responded_at + delivery.preparation_time_mins.minutes
        end
      end
    end

    private

    def can_dispatch_for_future?
      (delivery.deliver_at - delivery.preparation_time_mins.minutes) > Time.now
    end

    def calculate_dispatch_at?
      delivery.provider_responded_at.present? &&
        delivery.preparation_time_mins.present?
    end
  end
end
