module Api
  module Provider
    class BaseController < Api::BaseController
      before_action :authenticate_api_auth_user!
      before_action :verify_provider_is_active

      protected

      def verify_provider_is_active
        provider_profile = pundit_user.try :provider_profile
        if pundit_user.blank? || provider_profile.blank? || provider_profile.status.disabled?
          raise Pundit::NotAuthorizedError.new(
            t("provider_profile.errors.disabled")
          )
        end
      end
    end
  end
end
