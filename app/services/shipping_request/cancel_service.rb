class ShippingRequest < ActiveRecord::Base
  class CancelService < TransitionService
    def initialize(options)
      @shipping_request = options.fetch(:shipping_request)
      @reason = options.fetch(:reason)
    end

    def perform!
      in_transaction do
        assign_attributes
      end
      notify_android!
    end

    private

    def assign_attributes
      @shipping_request.assign_attributes(
        reason: @reason
      )
    end

    def paper_trail_event
      :canceled
    end

    def resource_transitions_to_status
      :canceled
    end
  end
end
