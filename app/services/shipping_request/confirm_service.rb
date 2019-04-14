class ShippingRequest < ActiveRecord::Base
  class ConfirmService < TransitionService
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
      notify_android!
    end

    private

    def notify_via_pusher!
      if @shipping_request.resource.is_a?(CustomerOrderDelivery)
        customer_order = @shipping_request.resource.customer_order
        ::CustomerOrder::PusherNotifierService.delay.notify!(customer_order)
      end
      # TODO notify errands!
    end

    def assign_attributes
      @shipping_request.assign_attributes(
        confirmed_at: Time.now,
        estimated_time_mins: @estimated_time_mins
      )
    end

    def paper_trail_event
      @custom_paper_trail_event.presence || :confirm_by_courier
    end

    def resource_transitions_to_status
      :confirmed
    end
  end
end
