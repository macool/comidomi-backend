class ShippingRequest < ActiveRecord::Base
  class DeliveredService < TransitionService
    def perform!
      in_transaction do
        # TODO notify or something
      end
    end

    private

    def paper_trail_event
      :delivered
    end

    def resource_status
      :delivered
    end
  end
end
