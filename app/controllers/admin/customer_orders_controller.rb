module Admin
  class CustomerOrdersController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "CustomerOrder"

    def index
      pundit_authorize
      @statuses = CustomerOrder.status.values
    end

    def show
      super
    end

    private

    def resources_with_status(status)
      @resources_with_status ||= {}
      @resources_with_status.fetch(status) {
        @resources_with_status[status] = resource_scope.with_status(status).latest.decorate
      }
    end
    helper_method :resources_with_status
  end
end
