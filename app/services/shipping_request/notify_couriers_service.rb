class ShippingRequest < ActiveRecord::Base
  class NotifyCouriersService
    class << self
      def run(notification_body, shipping_request_id)
        shipping_request = ShippingRequest.find(shipping_request_id)
        new(
          shipping_request: shipping_request,
          notification_body: notification_body
        ).notify!
      end
    end

    def initialize(notification_body:, shipping_request:)
      @shipping_request = shipping_request
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
        data: {
          notification_handler: :new_shipping_request,
          shipping_request: serialized_shipping_request
        },
        notification: {
          title: I18n.t("shipping_request.notifications.new_shipping_request"),
          body: @notification_body
        }
      )
      fail if resp[:status_code] != 200
    end

    def serialized_shipping_request
      view = ApplicationController.view_context_class.new(
        "#{Rails.root}/app/views/"
      )
      JbuilderTemplate.new(view).encode do |json|
        json.partial!(
          'api/courier/shipping_requests/shipping_request',
          shipping_request: @shipping_request
        )
      end
    end
  end
end
