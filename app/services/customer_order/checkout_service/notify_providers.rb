class CustomerOrder < ActiveRecord::Base
  class CheckoutService
    class NotifyProviders
      class << self
        def run(id)
          customer_order = CustomerOrder.find(id)
          new(customer_order).notify!
        end
      end

      def initialize(customer_order)
        @customer_order = customer_order
      end

      def notify!
        gather_recipients!
        notify_android!
      end

      private

      def gather_recipients!
        @android_recipients = []
        user_devices.each do |user_device|
          case user_device.platform
          when "android"
            @android_recipients << user_device.uuid
          end
        end
      end

      def notify_android!
        if @android_recipients.any?
          android_notifier.notify!(@android_recipients, notification)
        end
      end

      def notification
        {
          priority: "high",
          collapse_key: "provider_new_order",
          data: {
            visibility: 1,
            title: I18n.t("customer_order.notification.provider_new_order.title"),
            body: @customer_order.decorate.to_s,
            handler: "provider_new_order",
            order_id: @customer_order.id
          }
        }
      end

      def android_notifier
        PushService::AndroidNotifier.new
      end

      def user_devices
        @customer_order.deliveries.map do |delivery|
          delivery.provider_profile.user.user_devices
        end.flatten.compact
      end
    end
  end
end
