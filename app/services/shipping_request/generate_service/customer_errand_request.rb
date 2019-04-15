class ShippingRequest < ActiveRecord::Base
  module GenerateService
    class CustomerErrandRequest < GenericRequest
      DELIVERY_KIND = :customer_errand

      def initialize(resource:)
        @resource = resource
      end

      def perform!
        create_shipping_request!
        notify_couriers!
        call_couriers!
      end

      private

      def notify_couriers!
        errand_text = I18n.t("shipping_request.notifications.new_errand_request")
        NotifyCouriersService.delay.run(errand_text, @shipping_request.id)
      end

      def call_couriers!
        ::CallService::ScheduleCallingService.create_for_resource(
          @resource
        ).perform!
      end

      def create_shipping_request!
        @shipping_request = ShippingRequest.create!(
          kind: DELIVERY_KIND,
          place: @resource.place,
          resource: @resource,
          address_attributes: customer_address_attributes
        )
      end
    end
  end
end
