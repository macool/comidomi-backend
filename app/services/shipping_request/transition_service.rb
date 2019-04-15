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
        @shipping_request.status = resource_transitions_to_status
        @shipping_request.save!
      end
    end

    def notify_android!
      return if @shipping_request.kind.ask_to_validate?
      ::ShippingRequest::NotifyCustomersService.delay.run(
        @shipping_request.id,
        resource_transitions_to_status
      )
    end

    private

    def paper_trail_event
      raise NotImplementedError
    end

    def resource_transitions_to_status
      raise NotImplementedError
    end
  end
end
