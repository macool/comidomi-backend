module Api
  class BaseController < ::ApplicationController
    include ExceptionRescuable
    include JsonRequestsForgeryBypass
    include DeviseTokenAuth::Concerns::SetUserByToken

    alias_method :pundit_user, :current_api_auth_user

    # help airbrake identify current user
    alias_method :current_member, :current_api_auth_user
    # and expose it to views so it's accessible
    helper_method :current_member

    # strict pundit
    after_action :verify_authorized
    after_action :verify_policy_scoped

    protected

    def user_not_authorized
      render json: { error: I18n.t("pundit.not_authorized") },
             status: :unauthorized
    end

    def user_for_paper_trail
      pundit_user.id if pundit_user.present? # honour pundit
    end
  end
end
