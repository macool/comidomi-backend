class CustomerOrder < ActiveRecord::Base
  module ProviderResponse
    ##
    # a provider will accept a customer order
    # he's been requested providing an estimated
    # time for preparation
    class AcceptService < GenericResponseService
      ##
      # @return Boolean
      def perform
        return unless valid?
        in_transaction do
          update_delivery!
          create_shipping_request_if_necessary!
          notify_pusher!
        end
        true
      end

      def valid?
        preparation_time_mins = @request_params[:preparation_time_mins]
        preparation_time_mins.present? && preparation_time_mins.to_i > 0
      end

      private

      def default_paper_trail_event
        :provider_accept_delivery
      end

      def update_delivery!
        customer_order_delivery.assign_attributes(
          status: :accepted,
          provider_responded_at: Time.now,
          preparation_time_mins: @request_params[:preparation_time_mins]
        )
        customer_order_delivery.assign_attributes(
          dispatch_at: delivery_dispatch_at
        )
        customer_order_delivery.save!
      end

      def delivery_dispatch_at
        CustomerOrderDelivery::DispatchAtCalculatorService.new(
          customer_order_delivery
        ).dispatch_at
      end

      def create_shipping_request_if_necessary!
        return unless customer_order_delivery.delivery_method.shipping?
        ::ShippingRequest::GenerateService::CustomerOrderDeliveryRequest.new(
          resource: customer_order_delivery
        ).perform!
      end
    end
  end
end
