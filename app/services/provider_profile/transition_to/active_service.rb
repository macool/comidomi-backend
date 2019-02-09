class ProviderProfile < ActiveRecord::Base
  module TransitionTo
    class ActiveService < GenericTransitionService
      def perform
        return unless valid?
        transaction do
          update_state!
          cancel_shipping_request_if_any!
        end
      end

      private

      def cancel_shipping_request_if_any!
        if shipping_request.present?
          shipping_request.paper_trail_event = "canceled"
          shipping_request.update!(
            status: :canceled,
            reason: I18n.t("admin.provider_profile.transition.to.active")
          )
          shipping_request.paper_trail_event = nil
        end
      end

      def predicate
        :active
      end

      def shipping_request
        @shipping_request ||= ShippingRequest.with_status(
          :new, :assigned, :in_progress
        ).with_kind(:ask_to_validate)
         .find_by(resource: @provider_profile)
      end
    end
  end
end
