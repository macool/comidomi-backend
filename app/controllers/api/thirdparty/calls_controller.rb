module Api
  module Thirdparty
    class CallsController < ::ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        message = I18n.t(
          "shipping_request.courier_profile.new_customer_order",
          courier_name: courier_profile.nombres,
          provider_profiles_names: provider_profiles_names
        )
        twiml = Twilio::TwiML::VoiceResponse.new do |r|
          r.say(
            voice: "alice",
            loop: 2,
            language: "es-MX",
            message: message
          )
        end
        render text: twiml.to_s
      end

      private

      def provider_profiles_names
        new_shipping_requests.map do |shipping_request|
          shipping_request.resource.provider_profile
        end.uniq.map(&:nombre_establecimiento).join(", ")
      end

      def new_shipping_requests
        ShippingRequest.where(status: :new)
                       .where(kind: :customer_order_delivery)
                       .for_place(courier_profile.place)
      end

      def courier_profile
        @courier_profile ||= CourierProfile.find(params[:courier_profile_id])
      end
    end
  end
end
