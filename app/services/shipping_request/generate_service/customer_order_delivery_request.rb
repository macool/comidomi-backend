class ShippingRequest < ActiveRecord::Base
  module GenerateService
    class CustomerOrderDeliveryRequest
      DELIVERY_KIND = :customer_order_delivery

      def initialize(resource:)
        @customer_order_delivery = resource
      end

      def perform!
        create_shipping_request!
        notify_couriers!
      end

      private

      def notify_couriers!
        NotifyCouriersService.delay.run(@customer_order_delivery.id)
      end

      def create_shipping_request!
        ShippingRequest.create!(
          kind: DELIVERY_KIND,
          place: customer_order.place,
          resource: @customer_order_delivery,
          waypoints: [ provider_office_waypoint ],
          address_attributes: customer_address_attributes
        )
      end

      def customer_order
        @customer_order_delivery.customer_order
      end

      def provider_office_waypoint
        @customer_order_delivery
          .closest_provider_office
          .attributes
          .slice("lat", "lon")
      end

      def customer_address_attributes
        @customer_order_delivery
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
