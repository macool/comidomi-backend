module Admin
  class ShippingRequestsController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "ShippingRequest"

    def index
      pundit_authorize
    end

    def show
      super
    end

    def assign
      find_current_resource
      pundit_authorize
      courier_profile_id = params[:shipping_request][:courier_profile_id]
      ShippingRequest::TakeService.new(
        shipping_request: @current_resource.object,
        courier_profile: CourierProfile.find(courier_profile_id),
        estimated_time_mins: params[:shipping_request][:estimated_time_mins],
        event_name: :customer_service_assign
      ).perform!
      redirect_to(resource_path)
    end

    def cancel
      find_current_resource
      pundit_authorize
      ShippingRequest::CancelService.new(
        shipping_request: @current_resource.object,
        reason: params[:shipping_request][:reason]
      ).perform!
      redirect_to(resource_path)
    end

    private

    def resources_with_status(status)
      @resources_with_status ||= {}
      @resources_with_status.fetch(status) {
        @resources_with_status[status] = resource_scope.with_status(status).latest.includes(:resource).decorate
      }
    end
    helper_method :resources_with_status

    def courier_profiles_for_select
      CourierProfile.all.map do |courier_profile|
        [courier_profile.nombres, courier_profile.id]
      end
    end
    helper_method :courier_profiles_for_select
  end
end
