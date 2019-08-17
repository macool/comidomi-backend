module Api
  module Provider
    class LunchesController < Provider::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable

      self.resource_klass = ProviderLunch

      def_param_group :provider_lunch do
        param :precio, Float, required: true
      end

      api :POST,
          "/providers/lunches",
          "Create lunch"
      param_group :provider_lunch
      def create
        super
      end
    end
  end
end
