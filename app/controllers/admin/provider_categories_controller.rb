module Admin
  class ProviderCategoriesController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "ProviderCategory"

    def index
      pundit_authorize
      @resource_status = params[:status] || ProviderCategory.status.values.first
      @resource_collection = resource_scope.with_status(@resource_status)
                                           .by_titulo
                                           .decorate
    end

    def edit
      super
      @resource_status = @current_resource.status
    end

    def update
      super
    end

    private

    def resource_path
      by_status_admin_provider_categories_path(status: @current_resource.status)
    end
  end
end
