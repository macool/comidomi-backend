module Admin
  class BaseController < ::ApplicationController
    before_action :authenticate_admin!

    layout "admin"

    alias_method :pundit_user, :current_admin

    # help airbrake identify current user
    alias_method :current_member, :current_admin
    # and expose it to views so it's accessible
    helper_method :current_member

    # strict pundit
    after_action :verify_authorized
    after_action :verify_policy_scoped

    protected

    def t(key)
      I18n.t(key)
    end

    def decorated_current_admin
      @decorated_current_admin ||= current_admin.decorate
    end
    helper_method :decorated_current_admin

    private

    def user_for_paper_trail
      pundit_user.id if pundit_user.present? # honour pundit
    end
  end
end
