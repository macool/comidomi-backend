class ShippingRequest < ActiveRecord::Base
  class TransitionService
    def initialize(options)
      @courier_profile = options.fetch(:courier_profile)
      @shipping_request = options.fetch(:shipping_request)
    end

    protected

    def in_transaction(&block)
      @shipping_request.transaction do
        @shipping_request.paper_trail_event = paper_trail_event
        yield if block_given?
        @shipping_request.status = resource_status
        @shipping_request.save!
      end
    end

    private

    def paper_trail_event
      raise NotImplementedError
    end

    def resource_status
      raise NotImplementedError
    end
  end
end
