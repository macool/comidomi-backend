class CustomerOrderDelivery < ActiveRecord::Base
  class DeliveryAtCalculatorService
    def initialize(customer_order_delivery)
      @customer_order_delivery = customer_order_delivery
    end

    def courier_delivery_at
      if calculate_eta?
        shipping_request.estimated_delivery_at
      end
    end

    private

    def calculate_eta?
      shipping_request.present? &&
        shipping_request.estimated_time_mins.present?
    end

    def shipping_request
      @shipping_request ||= ShippingRequest.find_by(
        resource: @customer_order_delivery
      )
    end
  end
end
