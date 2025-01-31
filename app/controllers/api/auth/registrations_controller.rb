module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      extend BaseDoc
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        name "Auth::Registrations"
        short "user registration"
        description "registrations handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :create do
        api :POST,
            "/auth/user",
            "sign up providing email"
        description "create new account using email and given password and password confirmation. Responds with created user if successful"
        param :email, String, required: true
        param :password, String, required: true
        param :password_confirmation, String, required: true
      end

      private

      def resource_errors
        errs = @resource.errors.to_hash.inject({}) do |memo, (k, v)|
          memo[k] = v.uniq
          memo
        end
        return errs.merge(full_messages: @resource.errors.full_messages)
      end
    end
  end
end
