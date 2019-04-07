class ShippingRequest < ActiveRecord::Base
  class NotifyCouriersService
    class << self
      def run(notification_body)
        new(notification_body).notify!
      end
    end

    def initialize(notification_body)
      @notification_body = notification_body
    end

    def notify!
      notify_android!
    end

    private

    def notify_android!
      notifier = ::PushService::AndroidNotifier.new
      resp = notifier.notify_topic!(
        topic: "all_couriers",
        data: { notification_handler: :new_shipping_request },
        notification: {
          title: I18n.t("shipping_request.notifications.new_shipping_request"),
          body: @notification_body
        }
      )
      fail if resp[:status_code] != 200
    end
  end
end
