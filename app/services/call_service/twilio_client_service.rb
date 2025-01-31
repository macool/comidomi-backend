module CallService
  class TwilioClientService
    class FakeTwilioClient
      def calls; self; end
      def create(*args); end
    end

    def initialize
      @account_sid = Rails.application.secrets.twilio_account_sid
      @auth_token = Rails.application.secrets.twilio_auth_token
      @twilio_from = Rails.application.secrets.twilio_phone_number
    end

    def call(opts)
      default_opts = {
        from: @twilio_from,
        machine_detection: "Enable"
      }
      client.calls.create(
        opts.merge(default_opts)
      )
    end

    private

    def client
      @client ||= if Rails.application.secrets.twilio_account_sid.present?
        Twilio::REST::Client.new(@account_sid, @auth_token)
      else
        FakeTwilioClient.new
      end
    end
  end
end
