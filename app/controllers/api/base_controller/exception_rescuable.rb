module Api
  class BaseController < ::ApplicationController
    module ExceptionRescuable
      extend ActiveSupport::Concern

      included do
        def self.non_testing_env?
          !Rails.env.development? && !Rails.env.test?
        end

        rescue_from(
          ActionController::RoutingError,
          with: :redirect_to_frontend
        ) if non_testing_env?
      end

      protected

      def redirect_to_frontend
        error_path = "/#/error"
        uri = URI.parse(
          Rails.application.secrets.frontend_url + error_path
        )
        uri.query = URI.encode_www_form(
          error: I18n.t("api.something_went_wrong")
        )
        redirect_to uri.to_s
      end
    end
  end
end
