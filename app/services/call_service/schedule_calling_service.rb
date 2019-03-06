module CallService
  class ScheduleCallingService
    class << self
      def create_for_customer_order(customer_order)
        scheduled = ScheduledCourierCall.create!(
          customer_order: customer_order
        )
        new(scheduled)
      end
    end

    def initialize(scheduled_call)
      @scheduled_call = scheduled_call
    end

    def perform!
      CallCourierService.delay(
        run_at: 5.seconds.from_now
      ).run(
        @scheduled_call.id
      )
    end
  end
end
