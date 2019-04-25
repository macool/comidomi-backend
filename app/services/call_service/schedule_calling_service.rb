module CallService
  class ScheduleCallingService
    class << self
      def create_for_resource(resource)
        scheduled = ScheduledCourierCall.create!(resource: resource)
        new(scheduled)
      end
    end

    def initialize(scheduled_call)
      @scheduled_call = scheduled_call
    end

    def perform!
      CallCourierService.delay(
        run_at: 60.seconds.from_now
      ).run(
        @scheduled_call.id
      )
    end
  end
end
