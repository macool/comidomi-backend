module PushService
  class AndroidNotifier
    class FakeFCMClient
      def send(*args)
        return { status_code: 200 }
      end

      def send_to_topic(*args)
        return { status_code: 200 }
      end
    end

    ##
    # @deprecated
    # def notify!(recipients, notification)
    #   fcm_client.send(recipients, notification)
    # end

    def notify_ids!(registration_ids:, notification:, data: {})
      fcm_client.send(
        registration_ids,
        data: data,
        priority: "high",
        notification: notification.merge(default_notification_params)
      )
    end

    ##
    # @return FCM server response
    def notify_topic!(topic:, notification:, data: {})
      fcm_client.send_to_topic(
        topic,
        data: data,
        priority: "high",
        notification: notification.merge(default_notification_params)
      )
    end

    private

    def default_notification_params
      {
        icon: "fcm_push_icon",
        click_action: "FCM_PLUGIN_ACTIVITY"
      }
    end

    def fcm_client
      mock_fcm_client? ? mocked_fcm_client : real_fcm_client
    end

    def mock_fcm_client?
      (api_key.blank? || Rails.env.development? || Rails.env.test?) && !ENV["FORCE_PUSH_NOTIFICATIONS"]
    end

    def mocked_fcm_client
      FakeFCMClient.new
    end

    def real_fcm_client
      FCM.new(api_key)
    end

    def api_key
      Rails.application.secrets.google_fcm_key
    end
  end
end
