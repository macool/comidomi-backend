module Api
  module Thirdparty
    class CallsController < ::ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        twiml = if human_answered? && should_render_text?
          respond_with_message
        else
          hangup
        end
        render text: twiml.to_s
      end

      private

      def should_render_text?
        new_shipping_requests.count > 0 || new_errands.count > 0
      end

      def human_answered?
        params["AnsweredBy"] == "human"
      end

      def hangup
        Twilio::TwiML::VoiceResponse.new.hangup
      end

      def response_message
        messages = []
        if new_shipping_requests.count > 0
          messages << I18n.t(
            "shipping_request.courier_profile.new_customer_order",
            courier_name: courier_profile.forename,
            provider_profiles_names: provider_profiles_names
          )
        end
        if new_errands.count > 0
          messages << I18n.t(
            "shipping_request.courier_profile.new_errands",
            count: new_errands.count
          )
        end
        messages.join(
          " #{I18n.t("shipping_request.courier_profile.join_with")} "
        )
      end

      def respond_with_message
        Twilio::TwiML::VoiceResponse.new do |r|
          r.say(
            voice: "alice",
            language: "es-MX",
            message: response_message
          )
          r.hangup
        end
      end

      def provider_profiles_names
        new_shipping_requests.map do |shipping_request|
          shipping_request.resource.provider_profile
        end.uniq.map(&:nombre_establecimiento).join(", ")
      end

      def new_errands
        ShippingRequest.where(status: :new)
                       .where(kind: :customer_errand)
                       .for_place(courier_profile.place)
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
