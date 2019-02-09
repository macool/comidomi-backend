class ProviderProfile < ActiveRecord::Base
  module TransitionTo
    class AskToValidateService < GenericTransitionService
      def perform
        return unless valid?
        transaction do
          update_state!
          create_shipping_request!
        end
      end

      private

      def create_shipping_request!
        ShippingRequest.create!(
          place: main_office.place,
          kind: predicate,
          resource: @provider_profile,
          address_attributes: address_attributes
        )
      end

      def predicate
        :ask_to_validate
      end

      def perform_validations!
        validate_provider_profile!
        if !main_office.present?
          errors << I18n.t(
            "admin.provider_profile.transition.error.office_required"
          )
        else
          if !main_office.enabled?
            errors << I18n.t(
              "admin.provider_profile.transition.error.office_enabled_required"
            )
          end
        end
      end

      def main_office
        @main_office ||= @provider_profile.offices.first
      end

      def address_attributes
        main_office.attributes.slice(
          "lat",
          "lon",
          "place_id",
          "telefono",
          "direccion"
        )
      end
    end
  end
end
