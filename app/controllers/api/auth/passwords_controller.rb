module Api
  module Auth
    class PasswordsController < DeviseTokenAuth::PasswordsController
      extend BaseDoc
      include Api::BaseController::ExceptionRescuable
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        name "Auth::Passwords"
        short "password reset"
        description "password recovery functionality handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :create do
        api :POST,
            "/auth/user/password",
            "reset password providing email"
        param :email, String, required: true
        param :redirect_url, String, required: true
      end

      doc_for :edit do
        api :GET,
            "/auth/user/password/edit",
            "verify user by password reset token"
        description "this is the URL generated in the reset password feature. will allow user to update password"
        param :redirect_url, String, required: true
        param :reset_password_token, String, required: true
      end

      doc_for :update do
        api :PUT,
            "/auth/user/password",
            "update account's password"
        param :password, String, required: true
        param :password_confirmation, String, required: true
      end
    end
  end
end
