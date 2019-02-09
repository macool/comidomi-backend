module Admin
  class ResourceVersionController < BaseController
    def show
      pundit_authorize
      @version = scoped.find(params[:id]).decorate
    end

    private

    def pundit_authorize
      raise Pundit::NotAuthorizedError unless resource_policy.show?
    end

    def resource_policy
      skip_authorization
      policy_klass.new(
        pundit_user,
        PaperTrail::Version
      )
    end

    def scoped
      skip_policy_scope
      policy_klass::Scope.new(
        pundit_user,
        PaperTrail::Version
      ).resolve
    end

    def policy_klass
      Admin::PaperTrailPolicy
    end
  end
end
