module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      extend BaseDoc
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        name "Auth::Sessions"
        short "user session"
        description "sessions handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :sign_in do
        api :POST,
            "/auth/user/sign_in",
            "login"
        description "authenticate using email and password. Response includes full provider profile and courier profile if present"
        see "provider-profiles#create", "Provider::Profiles#create for provider_profile serialization"
        see "courier-profiles#create", "Courier::Profiles#create for courier_profile serialization"
        param :email, String, required: true
        param :password, String, required: true
        example %q{{
  "data": {
    "type":"user",
    "id":1,
    "provider":"email",
    "uid":"user-1@noggalito.com",
    "name":null,
    "nickname":null,
    "image":null,
    "email":"user-1@noggalito.com",
    "info":null,
    "credentials":null,
    "agreed_tos":true,
    "provider_profile":{
      #see provider_profile serialization
    },
    "courier_profile":{
      #see courier_profile serialization
    }
  }
}}
      end

      doc_for :sign_out do
        api :DELETE,
            "/auth/user/sign_out",
            "log out"
        description "aka end session"
      end

      protected

      def render_create_success
        render "api/auth/sessions/user"
      end
    end
  end
end
