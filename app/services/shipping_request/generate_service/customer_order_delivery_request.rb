class ShippingRequest < ActiveRecord::Base
  module GenerateService
    class CustomerOrderDeliveryRequest < GenericRequest
      DELIVERY_KIND = :customer_order_delivery

      def initialize(resource:)
        @resource = resource
      end

      def perform!
        create_shipping_request!
        notify_couriers!
      end

      private

      def notify_couriers!
        nombre_establecimiento = @resource.provider_profile.nombre_establecimiento
        NotifyCouriersService.delay.run(nombre_establecimiento, @shipping_request.id)
      end

      def create_shipping_request!
        @shipping_request = ShippingRequest.create!(
          kind: DELIVERY_KIND,
          place: customer_order.place,
          resource: @resource,
          waypoints: [ provider_office_waypoint ],
          address_attributes: customer_address_attributes
        )
      end

      def customer_order
        @resource.customer_order
      end

      def provider_office_waypoint
        @resource
          .closest_provider_office
          .attributes
          .slice("lat", "lon")
      end
    end
  end
end
