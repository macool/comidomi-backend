class ShippingRequest < ActiveRecord::Base
  class NotifyCustomersService
    class << self
      def run(shipping_request_id, transitions_to)
        shipping_request = ShippingRequest.find(shipping_request_id)
        new(
          transitions_to: transitions_to,
          shipping_request: shipping_request
        ).notify!
      end
    end

    def initialize(transitions_to:, shipping_request:)
      @transitions_to = transitions_to
      @shipping_request = shipping_request
    end

    def notify!
      notify_android!
    end

    private

    def recipient_ids
      @shipping_request.resource.customer_profile.user.user_devices.with_platform(:android).map(&:uuid)
    end

    def notify_android!
      notifier = ::PushService::AndroidNotifier.new
      resp = notifier.notify_ids!(
        registration_ids: recipient_ids,
        notification: notification_description,
        data: {
          notification_handler: :customer_request_updated,
          customer_resource: serialized_customer_resource,
          notification_description: notification_description
        }
      )
      fail if resp[:status_code] != 200
    end

    def notification_description
      {
        title: notification_title,
        body: notification_body
      }
    end

    def notification_title
      I18n.t(
        "shipping_request.customer_notifications.to_status.#{@transitions_to}"
      )
    end

    def notification_body
      if @transitions_to == :confirmed
        opts = { eta: @shipping_request.estimated_time_mins }
      else
        opts = {}
      end
      I18n.t(
        "shipping_request.customer_notifications.to_status_body.#{@transitions_to}",
        opts
      )
    end

    def serialized_customer_resource
      view = ApplicationController.view_context_class.new(
        "#{Rails.root}/app/views/"
      )
      JbuilderTemplate.new(view).encode do |json|
        json.partial!(
          'api/customer/orders/customer_resource',
          customer_resource: customer_resource
        )
      end
    end

    def customer_resource
      case @shipping_request.resource
      when CustomerOrderDelivery
        @shipping_request.resource.customer_order
      else
        @shipping_request.resource
      end
    end
  end
end
