module Admin
  class ShippingFaresController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "ShippingFare"

    before_action :find_place

    def new
      super
      @current_resource.set_place_currency!
    end

    def create
      super
    end

    def edit
      super
    end

    def update
      super
    end

    def destroy
      find_current_resource
      pundit_authorize
      @current_resource.destroy
      redirect_to(
        resource_path,
        notice: t("admin.#{resource_type.underscore}.destroyed")
      )
    end

    private

    def resource_scope
      skip_policy_scope
      pundit_policy_class::Scope.new(
        pundit_user,
        @place.shipping_fares
      ).resolve
    end

    def find_place
      @place ||= Admin::PlacePolicy::Scope.new(
        pundit_user,
        Place
      ).resolve.find(params[:place_id])
    end

    def resource_path
      admin_places_path
    end
  end
end
