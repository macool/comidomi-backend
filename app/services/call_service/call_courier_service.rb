module CallService
  class CallCourierService
    class << self
      def run(scheduled_call_id)
        scheduled_call = ScheduledCourierCall.find(scheduled_call_id)
        new(scheduled_call).call!
      end
    end

    def initialize(scheduled_call)
      @scheduled_call = scheduled_call
    end

    def call!
      if @scheduled_call.done? || no_new_shipping_requests? || next_courier.blank?
        return
      end
      call_via_twilio!
      update_scheduled_call!
      update_old_scheduled_calls!
      schedule_next_call!
    end

    private

    def schedule_next_call!
      ScheduleCallingService.new(@scheduled_call).perform!
    end

    def update_scheduled_call!
      @scheduled_call.couriers_called_ids << next_courier.id
      @scheduled_call.save
    end

    def update_old_scheduled_calls!
      ScheduledCourierCall.where(
        done: false
      ).where.not(
        id: @scheduled_call.id
      ).update_all(done: true)
    end

    def no_new_shipping_requests?
      customer_order = @scheduled_call.customer_order
      customer_order.deliveries.none? do |delivery|
        delivery.shipping_request.status.new?
      end
    end

    def call_via_twilio!
      twilio_client = TwilioClientService.new
      twilio_client.call(
        to: next_courier.telefono,
        url: callback_url
      )
    end

    def callback_url
      scheme = Rails.application.config.force_ssl ? "https" : "http"
      path = Rails.application.routes.url_helpers.api_thirdparty_calls_path(format: :xml)
      host = Rails.application.secrets.host
      "#{scheme}://#{host}#{path}?courier_profile_id=#{next_courier.id}"
    end

    def next_courier
      @next_courier ||= ::ScheduledCourierCall::QueueService.new(
        @scheduled_call
      ).next_courier
    end
  end
end
