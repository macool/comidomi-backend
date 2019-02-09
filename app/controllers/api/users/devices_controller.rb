module Api
  module Users
    class DevicesController < BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable

      resource_description do
        name "Users::Devices"
        short "users' devices"
      end

      self.resource_klass = UserDevice

      before_action :authenticate_api_auth_user!

      api :POST,
          "/users/devices",
          "register user's device"
      param :uuid, String, required: true
      param :platform,
            UserDevice.platform.values,
            required: true
      def create
        super
      end

      private

      def pundit_authorize_resource
        authorize(@api_resource.user_device)
      end

      def new_api_resource
        @api_resource = UserDevice::RegisterService.new(
          params,
          resource_scope
        )
      end
    end
  end
end
