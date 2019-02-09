module Admin
  class UsersController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "User"

    def index
      pundit_authorize
      @resource_status = by_status || "all"
      @resource_collection =
        resource_scope.send(@resource_status)
                      .page(params[:page]).per(9)
                      .decorate
    end

    def show
      super
      @resource_status = @current_resource.highest_privilege
    end

    def edit
      super
      @resource_status = @current_resource.highest_privilege
    end

    def new
      super
    end

    def create
      super
    end

    def update
      super
    end

    private

    def by_status
      # avoid pulling directly from params
      (User::PRIVILEGES.map(&:to_s) & [params[:status]]).first
    end

    def user_scopes
      [ "all" ] + User.privileges.values
    end
    helper_method :user_scopes

    def resource_params
      return if params[:user].blank?
      attributes = if params[:user][:password].present?
        pundit_policy.permitted_attributes_with_password
      else
        pundit_policy.permitted_attributes
      end
      params.require(:user)
            .permit(attributes)
    end
  end
end
