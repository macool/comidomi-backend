class CustomerOrder < ActiveRecord::Base
  module ProviderResponse
    class GenericResponseService
      def initialize(provider, customer_order, request_params)
        @provider = provider
        @customer_order = customer_order
        @request_params = request_params
      end

      protected

      def in_transaction(&block)
        @customer_order.transaction do
          @customer_order.paper_trail_event = paper_trail_event
          @customer_order.touch_with_version
          yield if block_given?
        end
      end

      def paper_trail_event
        raise NotImplementedError
      end

      def customer_order_delivery
        @customer_order_delivery ||= @customer_order.delivery_for_provider(
          @provider.provider_profile
        )
      end

      def notify_pusher!
        CustomerOrder::PusherNotifierService.delay.notify!(@customer_order)
      end
    end
  end
end
