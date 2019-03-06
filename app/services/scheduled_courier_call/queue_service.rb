class ScheduledCourierCall < ActiveRecord::Base
  class QueueService
    def initialize(scheduled_call)
      @scheduled_call = scheduled_call
      @customer_order = @scheduled_call.customer_order
    end

    def next_courier
      sorted_couriers.to_a.detect do |courier_profile|
        !@scheduled_call.couriers_called_ids.include?(
          courier_profile.id.to_s
        )
      end
    end

    private

    def sorted_couriers
      CourierProfile.receive_calls
                    .for_place(@customer_order.place)
                    .by_priority
    end
  end
end
