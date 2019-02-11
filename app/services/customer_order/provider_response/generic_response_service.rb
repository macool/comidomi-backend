class CustomerOrder < ActiveRecord::Base
  module ProviderResponse
    class GenericResponseService
      def initialize(provider:, customer_order:, request_params:, event_name: nil)
        @provider = provider
        @customer_order = customer_order
        @request_params = request_params
        @custom_paper_trail_event = event_name
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
        @custom_paper_trail_event.presence || default_paper_trail_event
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
