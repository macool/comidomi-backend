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
        resource_scope.with_status(:submitted).latest
      end
    end
  end
end
