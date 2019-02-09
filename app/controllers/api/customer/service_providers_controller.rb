module Api
  module Customer
    class ServiceProvidersController < Customer::BaseController
      include Api::BaseController::Scopable

      resource_description do
        name "Customer::ServiceProviders"
        short "service providers. for a customer. ie. sorted by opening time"
      end

      self.resource_klass = ProviderProfile

      api :GET,
          "/customer/service_providers",
          "service providers sorted by opening time"
      description "**NB** this endpoint returns a simplified version of the provider public profile"
      see "providers#index", "Categories::Providers#index for provider profile serialization"
      def show
        pundit_authorize :customer_show
        @api_collection = resource_scope.all
      end

      private

      def resource_scope
        skip_policy_scope
        pundit_policy_class::PublicScope.new(pundit_user, resource_klass).resolve
      end

      def pundit_authorize(action = nil)
        skip_authorization
        action = action_name if action.nil?
        klass_policy = pundit_policy_class.new(pundit_user, resource_klass)
        raise Pundit::NotAuthorizedError unless klass_policy.send("#{action}?")
      end

      def pundit_policy_class
        "Api::#{resource_klass}Policy".constantize
      end
    end
  end
end
