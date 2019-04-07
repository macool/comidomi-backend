module Api
  module Customer
    class ErrandsController < Customer::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable

      before_action :authenticate_api_auth_user!
      before_action :find_or_create_customer_profile

      self.resource_klass = CustomerErrand

      def create
        super
      end

      def show
        super
      end

      private

      def new_api_resource
        @api_resource = CustomerErrand::RequestService.new(
          user: current_api_auth_user,
          parameters: resource_params,
          resource_scope: resource_scope
        )
      end

      def pundit_authorize_resource
        authorize CustomerErrand
      end

      def resource_template
        action_name
      end
    end
  end
end
