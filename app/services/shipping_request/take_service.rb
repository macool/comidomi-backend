class ShippingRequest < ActiveRecord::Base
  class TakeService < InStoreService
    def initialize(options)
      super
      @estimated_time_mins = options.fetch(:estimated_time_mins)
    end

    def perform!
      in_transaction do
        assign_attributes
      end
    end

    private

    def assign_attributes
      @shipping_request.assign_attributes(
        assigned_at: Time.now,
        courier_profile: @courier_profile,
        estimated_time_mins: @estimated_time_mins
      )
    end

    def paper_trail_event
      :take_by_courier
    end

    def resource_status
      :assigned
    end
  end
end
