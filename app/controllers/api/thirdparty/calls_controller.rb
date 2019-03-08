module Api
  module Thirdparty
    class CallsController < ::ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        twiml = if human_answered? && new_shipping_requests.count > 0
          respond_with_message
        else
          hangup
        end
        render text: twiml.to_s
      end

      private

      def human_answered?
        params["AnsweredBy"] == "human"
      end

      def hangup
        Twilio::TwiML::VoiceResponse.new.hangup
      end

      def respond_with_message
        message = I18n.t(
          "shipping_request.courier_profile.new_customer_order",
          courier_name: courier_profile.forename,
          provider_profiles_names: provider_profiles_names
        )
        Twilio::TwiML::VoiceResponse.new do |r|
          r.say(
            voice: "alice",
            language: "es-MX",
            message: message
          )
          r.hangup
        end
      end

      def provider_profiles_names
        new_shipping_requests.map do |shipping_request|
          shipping_request.resource.provider_profile
        end.uniq.map(&:nombre_establecimiento).join(", ")
      end

      def new_shipping_requests
        ShippingRequest.where(status: :new)
                       .where(kind: :customer_order_delivery)
                       .for_place(courier_profile.place)
                       .includes(resource: :provider_profile)
      end

      def courier_profile
        @courier_profile ||= CourierProfile.find(params[:courier_profile_id])
      end
    end
  end
end
