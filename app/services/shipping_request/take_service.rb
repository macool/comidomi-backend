class ShippingRequest < ActiveRecord::Base
  class TakeService < TransitionService
    def initialize(options)
      super
      @estimated_time_mins = options.fetch(:estimated_time_mins)
      @custom_paper_trail_event = options[:event_name]
    end

    def perform!
      in_transaction do
        assign_attributes
      end
      notify_via_pusher!
    end

    private

    def notify_via_pusher!
      if @shipping_request.resource.is_a?(CustomerOrderDelivery)
        customer_order = @shipping_request.resource.customer_order
        ::CustomerOrder::PusherNotifierService.delay.notify!(customer_order)
      end
    end

    def assign_attributes
      @shipping_request.assign_attributes(
        assigned_at: Time.now,
        courier_profile: @courier_profile,
        estimated_time_mins: @estimated_time_mins
      )
    end

    def paper_trail_event
      @custom_paper_trail_event.presence || :take_by_courier
    end

    def resource_status
      :assigned
    end
  end
end
