module Admin
  class ProviderItemCategoriesController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "ProviderItemCategory"

    def index
      pundit_authorize
      @resource_collection = resource_scope.by_nombre.decorate
    end

    def new
      super
    end

    def edit
      super
    end

    def create
      super
    end

    def update
      super
    end

    private

    def resource_path
      admin_provider_item_categories_path
    end
  end
end
