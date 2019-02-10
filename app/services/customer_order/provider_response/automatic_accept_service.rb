class CustomerOrder < ActiveRecord::Base
  module ProviderResponse
    class AutomaticAcceptService < GenericResponseService
      class AutomaticAcceptSpecificDeliveryService
        def initialize(customer_order_delivery)
          @customer_order_delivery = customer_order_delivery
        end

        def perform!
          update_delivery!
          create_shipping_request_if_necessary!
        end

        private

        def update_delivery!
          @customer_order_delivery.assign_attributes(
            status: :accepted,
            provider_responded_at: Time.now,
            preparation_time_mins: 0
          )
          @customer_order_delivery.assign_attributes(
            dispatch_at: delivery_dispatch_at
          )
          @customer_order_delivery.save!
        end

        def delivery_dispatch_at
          CustomerOrderDelivery::DispatchAtCalculatorService.new(
            @customer_order_delivery
          ).dispatch_at
        end

        def create_shipping_request_if_necessary!
          return unless @customer_order_delivery.delivery_method.shipping?
          ::ShippingRequest::GenerateService::CustomerOrderDeliveryRequest.new(
            resource: @customer_order_delivery
          ).perform!
        end
      end

      def initialize(customer_order)
        @customer_order = customer_order
        @customer_order_deliveries = @customer_order.deliveries
      end

      ##
      # @return Boolean
      def perform
        @customer_order_deliveries.each do |customer_order_delivery|
          in_transaction do
            AutomaticAcceptSpecificDeliveryService.new(
              customer_order_delivery
            ).perform!
          end
        end
        true
      end

      private

      def paper_trail_event
        :automatic_accept_delivery
      end
    end
  end
end
