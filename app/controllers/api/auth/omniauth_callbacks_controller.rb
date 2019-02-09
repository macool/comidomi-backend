module Api
  module Auth
    class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
      extend BaseDoc
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        name "Auth::OmniauthCallbacks"
        short "authenticate users using oauth"
        description "oauth handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :redirect_callbacks do
        api :GET,
            "/auth/user/:provider",
            "authorise a user using specified provider"
        param :provider, String, required: true
        param :auth_origin_url, String, required: true
      end
      # TODO save birthday

      protected

      # HACK
      # taken from github to make it work
      # https://github.com/lynndylanhurley/devise_token_auth/blob/1d6dbdc2e5ba2de00264362a8a876dc98585bd0c/app/controllers/devise_token_auth/omniauth_callbacks_controller.rb
      def resource_class
        User
      end

      def assign_provider_attrs(user, auth_hash)
        user.assign_attributes({
          nickname: auth_hash['info']['nickname'],
          name:     auth_hash['info']['name'],
          image:    auth_hash['info']['image'],
          email:    auth_hash['info']['email']
        })
        user.will_cache_facebook_image!
      end

      def devise_mapping
        request.env['devise.mapping']
      end

      def auth_hash
        request.env['omniauth.auth']
      end

      def resource_json
        views = ApplicationController.view_context_class.new(
          "#{Rails.root}/app/views/"
        )
        JbuilderTemplate.new(views).encode do |json|
          json.partial! 'api/auth/sessions/user', user: @resource
        end
      end
      helper_method :resource_json
    end
  end
end
