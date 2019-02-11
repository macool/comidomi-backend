class CustomerOrder < ActiveRecord::Base
  module ProviderResponse
    ##
    # a provider may reject a customer order
    # providing a reason
    class RejectService < GenericResponseService
      ##
      # @return Boolean
      def perform
        return unless valid?
        in_transaction do
          mark_as_rejected!
          notify_pusher!
        end
        true
      end

      def valid?
        @request_params[:reason].present?
      end

      private

      def default_paper_trail_event
        :provider_reject_delivery
      end

      def mark_as_rejected!
        customer_order_delivery.update!(
          status: :rejected,
          reason: @request_params[:reason],
          provider_responded_at: Time.now
        )
      end
    end
  end
end
