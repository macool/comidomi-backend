module Api
  module Customer
    class OrdersController < Customer::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Customer::BaseController::ResourceCollectionable

      resource_description do
        name "Customer::Orders"
        short "customer's previous orders"
      end

      self.resource_klass = CustomerOrder

      before_action :authenticate_api_auth_user!

      api :GET,
          "/customer/orders",
          "customer's previous orders"
      see "customer-cart-items#index", "Customer::Cart::Items#index for customer order serialization in response"
      def index
        super
      end

      api :GET,
          "/customer/orders/:id",
          "get a customer's previous order"
      see "customer-cart-items#index", "Customer::Cart::Items#index for customer order serialization in response"
      def show
        super
      end

      private

      def collection_scope
        # ATM we don't support scoping more than
        # one resource class
        customer_orders = resource_scope.with_status(:submitted).latest
        customer_errands = policy_scope(CustomerErrand).latest
        collection = customer_orders.to_a + customer_errands.to_a
        collection.sort_by(&:created_at).reverse
      end
    end
  end
end
