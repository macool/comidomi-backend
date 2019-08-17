module Admin
  class ProviderLunchesController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "ProviderLunch"

    def index
      pundit_authorize
      @resource_collection =
        resource_scope.includes(:lunch_items)
                      .page(params[:page])
                      .decorate
    end
  end
end
