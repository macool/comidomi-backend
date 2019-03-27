class ShippingRequest < ActiveRecord::Base
  module GenerateService
    class CustomerErrandRequest < GenericRequest
      DELIVERY_KIND = :customer_errand

      def initialize(resource:)
        @customer_errand = resource
      end

      def perform!
        create_shipping_request!
        # TODO
        # notify_couriers!
        # call_couriers! at controller?
      end

      private

      def create_shipping_request!
        ShippingRequest.create!(
          kind: DELIVERY_KIND,
          place: @customer_errand.place,
          resource: @customer_errand,
          address_attributes: customer_address_attributes
        )
      end
    end
  end
end
