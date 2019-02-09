module Api
  module Users
    class PlacesController < BaseController
      resource_description do
        name "Users::Places"
        short "available places"
      end

      before_action :authenticate_api_auth_user!
      before_action :pundit_authorize

      api :GET,
          "/users/places",
          "available places for users"
      example %q{{
  "places":[
    {
      "id":1,
      "lat":"68.51347127881408",
      "lon":"-140.60960733991016",
      "nombre":"Valdemoro",
      "country":"Guinea Ecuatorial"
    },
    {
      "id":2,
      "lat":"-39.54014749562829",
      "lon":"54.68961421514123",
      "nombre":"Baracaldo",
      "country":"Andorra"
    }
  ]
}}
      def index
        @api_collection = resource_scope.sorted.decorate
      end

      private

      def resource_scope
        policy_scope(Place)
      end

      def pundit_authorize
        authorize(Place)
      end
    end
  end
end
