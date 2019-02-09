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
        @request_params[:preparation_time_mins].present?
      end

      private

      def paper_trail_event
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
        if customer_order_delivery.delivery_method.shipping?
          ShippingRequest.create!(
            place: @customer_order.place,
            kind: :customer_order_delivery,
            resource: customer_order_delivery,
            waypoints: [ provider_office_waypoint ],
            address_attributes: customer_address_attributes
          )
        end
      end

      def provider_office_waypoint
        customer_order_delivery
          .closest_provider_office
          .attributes
          .slice("lat", "lon")
      end

      def customer_address_attributes
        customer_order_delivery
          .customer_address
          .attributes
          .slice(
            "lat",
            "lon",
            "ciudad",
            "barrio",
            "nombre",
            "parroquia",
            "referencia",
            "direccion_uno",
            "direccion_dos",
            "codigo_postal",
            "numero_convencional"
          )
      end
    end
  end
end
