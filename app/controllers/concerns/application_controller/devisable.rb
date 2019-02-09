# override some devise stuff
class ApplicationController < ActionController::Base
  module Devisable
    def new_session_path(scope)
      if scope == :api_auth_user
        # send along to frontend with error params
        uri = URI.parse(frontend_url)
        uri.query = URI.encode_www_form(params)
        uri.to_s
      else
        fail
      end
    end

    protected

    def after_sign_in_path_for(resource)
      request.env['omniauth.origin'] || stored_location_for(resource) || path_for(resource)
    end

    def path_for(resource)
      if request.referrer == admin_session_url
        admin_root_path
      else
        root_path
      end
    end

    private

    def frontend_url
      Rails.application.secrets.frontend_url
    end
  end
end
