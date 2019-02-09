module Api
  module Users
    class AccountsController < BaseController
      resource_description do
        name "Users::Accounts"
        short "user's account"
      end

      before_action :authenticate_api_auth_user!
      before_action :authorize_user!

      api :GET,
          "/users/account",
          "get User's account"
      example %q{{
  "user":{
    "id":2,
    "name":"Ana María Cornejo Vásquez",
    "email":"darlene@collierfranecki.biz",
    "ciudad":"Móstoles",
    "fecha_nacimiento":"1973-08-06",
    "custom_image_url": null
  }
}}
      def show
      end

      api :PUT,
          "/users/account",
          "Update user account"
      see "users-places#index", "User::Places#index for available places"
      param :name, String
      param :email, String
      param :ciudad, String
      param :custom_image, File
      param :fecha_nacimiento, Date
      param :current_place_id, Integer
      param :password, String, "if you want to update your account's password"
      def update
        if @api_resource.update(user_params)
          @resource = @api_resource
          render "api/auth/sessions/user", status: :accepted
        else
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def user_params
        attributes = if params[:password].present?
          policy(User).permitted_attributes_with_password
        else
          policy(User).permitted_attributes
        end
        params.permit(attributes)
      end

      def authorize_user!
        authorize User
        @api_resource = policy_scope(User)
      end
    end
  end
end
