module PushService
  class AndroidNotifier
    class FakeGCMClient
      def send(*args); end
    end

    def notify!(recipients, notification)
      gcm_client.send(recipients, notification)
    end

    private

    def gcm_client
      mock_gcm_client? ? mocked_gcm_client : real_gcm_client
    end

    def mock_gcm_client?
      (api_key.blank? || Rails.env.development? || Rails.env.test?) && !ENV["FORCE_PUSH_NOTIFICATIONS"]
    end

    def mocked_gcm_client
      FakeGCMClient.new
    end

    def real_gcm_client
      GCM.new(api_key)
    end

    def api_key
      Rails.application.secrets.google_gcm_key
    end
  end
end
