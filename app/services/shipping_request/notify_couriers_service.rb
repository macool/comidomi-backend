class ShippingRequest < ActiveRecord::Base
  class NotifyCouriersService
    class << self
      def run(customer_order_delivery_id)
        customer_order_delivery = CustomerOrderDelivery.find(customer_order_delivery_id)
        new(customer_order_delivery).notify!
      end
    end

    def initialize(customer_order_delivery)
      @customer_order_delivery = customer_order_delivery
    end

    def notify!
      notify_android!
    end

    private

    def notify_android!
      notifier = ::PushService::AndroidNotifier.new
      resp = notifier.notify_all!(notification: {
        title: I18n.t("shipping_request.notifications.new_shipping_request"),
        body: nombre_establecimiento
      })
      fail if resp[:status_code] != 200
    end

    def nombre_establecimiento
      @customer_order_delivery.provider_profile.nombre_establecimiento
    end
  end
end
