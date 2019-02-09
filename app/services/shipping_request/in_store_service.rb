class ShippingRequest < ActiveRecord::Base
  class InStoreService < TransitionService
    def perform!
      in_transaction do
        # TODO notify or something
      end
    end

    private

    def paper_trail_event
      :courier_in_store
    end

    def resource_status
      :in_progress
    end
  end
end
