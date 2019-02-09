module Api
  module Provider
    class CustomerOrdersController < Provider::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Provider::BaseController::ResourceCollectionable

      resource_description do
        name "Provider::CustomerOrders"
        short "provider's customer orders"
        description "customer orders will contain only current provider's profile"
      end

      self.resource_klass = CustomerOrder

      before_action :authenticate_api_auth_user!

      api :GET,
          "/provider/customer_orders",
          "List provider's customer orders"
      param :status,
            CustomerOrder.status.values,
            desc: "orders' status"
      see "customer-orders#index", "Customer::Orders#index for customer order serialization in response"
      def index
        pundit_authorize
        skip_policy_scope
        # TODO write some specs for this shit
        api_status = if params[:status] == "completed"
          [:accepted, :rejected]
        elsif params[:status] == "submitted"
          :pending
        end
        @api_collection = Api::Provider::CustomerOrderPolicy::Scope.new(
          pundit_user,
          resource_klass
        ).resolve(api_status)
        @api_collection = @api_collection.latest
      end

      api :GET,
          "/provider/customer_orders/:id",
          "Show a provider's customer order"
      param :id, Integer, required: true, desc: "unique id for customer order"
      see "customer-orders#index", "Customer::Orders#index for customer order serialization in response"
      def show
        super
      end

      api :POST,
          "/provider/customer_orders/:id/accept",
          "Accept a pending customer order"
      param :preparation_time_mins, Integer, required: true, desc: "Estimated time for preparation (in minutes)"
      see "customer-orders#index", "Customer::Orders#index for customer order serialization in response"
      def accept
        find_api_resource
        pundit_authorize_resource
        if accept_service.perform
          render resource_template, status: :accepted
        else
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :POST,
          "/provider/customer_orders/:id/reject",
          "Reject a pending customer order"
      param :reason, String, desc: "reason from the provider for rejection"
      see "customer-orders#index", "Customer::Orders#index for customer order serialization in response"
      def reject
        find_api_resource
        pundit_authorize_resource
        if reject_service.perform
          render resource_template, status: :accepted
        else
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def accept_service
        CustomerOrder::ProviderResponse::AcceptService.new(
          pundit_user,
          @api_resource,
          params
        )
      end

      def reject_service
        CustomerOrder::ProviderResponse::RejectService.new(
          pundit_user,
          @api_resource,
          params
        )
      end

      def resource_scope
        skip_policy_scope
        Api::Provider::CustomerOrderPolicy::Scope.new(
          pundit_user,
          resource_klass
        ).resolve
      end

      def pundit_authorize
        if provider_policy(resource_klass).send("#{action_name}?")
          skip_authorization
        else
          raise Pundit::NotAuthorizedError
        end
      end

      def pundit_authorize_resource
        if provider_policy(@api_resource).send("#{action_name}?")
          skip_authorization
        else
          raise Pundit::NotAuthorizedError
        end
      end

      def provider_policy(subject)
        Api::Provider::CustomerOrderPolicy.new pundit_user, subject
      end

      def current_provider_profile
        pundit_user.provider_profile
      end
      helper_method :current_provider_profile
    end
  end
end
