module Api
  module Users
    class TosController < BaseController
      resource_description do
        name "Users::TOS"
        short "agree to terms & conditions"
      end

      before_action :authenticate_api_auth_user!
      before_action :authorize_user!

      api :POST,
          "/users/tos",
          "user agress TOS"
      def create
        @api_resource.update! agreed_tos: true
        head :accepted
      end

      private

      def authorize_user!
        authorize User, :agree_tos?
        @api_resource = policy_scope(User)
      end
    end
  end
end
