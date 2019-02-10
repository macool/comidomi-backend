module Api
  module Customer
    module Cart
      class CheckoutsController < Api::Customer::BaseController
        include Api::BaseController::Scopable
        include Api::BaseController::Resourceable

        resource_description do
          name "Customer::Cart::Checkout"
          short "checkout current cart"
          description "aka place an order"
        end

        self.resource_klass = CustomerOrder

        before_action :authenticate_api_auth_user!
        before_action :find_or_create_customer_profile
        before_action :find_current_order

        api :POST,
            "/customer/cart/checkout",
            "responds with full `customer_order`"
        see "customer-cart-items#index", "Customer::Cart::Items#index for customer order serialization in response"
        see "customer-cart-deliveries#update", "Customer::Cart::Deliveries#update for deliveries attributes"
        param :observaciones,
              String,
              desc: "observaciones para el pedido. ej: timbre al llegar"
        param :forma_de_pago,
              CustomerOrder::FORMAS_DE_PAGO,
              required: true
        param :anon_billing_address,
              TrueClass,
              desc: "para consumidor final. No incluir dirección de facturación"
        param :customer_billing_address_id,
              Integer,
              desc: "dirección de facturación. requerida si no es para consumidor final"
        param :deliveries_attributes,
              Hash,
              desc: "deliveries attributes - one required per provider profile" do
          param :id,
                Integer,
                desc: "unique for each delivery"
        end
        def create
          super
        end

        private

        def resource_template
          "api/customer/cart/customer_order"
        end

        def new_api_resource
          @api_resource = CustomerOrder::CheckoutService.new(
            current_api_auth_user,
            @customer_order,
            resource_params
          )
        end

        ##
        # @note at the moment after an order is submitted
        # we're automatically accepting the request & creating
        # shipping requests
        def after_create_api_resource
          CustomerOrder::ProviderResponse::AutomaticAcceptService.new(
            @customer_order
          ).perform
        end

        def pundit_authorize_resource
          authorize @customer_order, :checkout?
        end

        def find_current_order
          skip_policy_scope
          @customer_order = @customer_profile.current_order
        end
      end
    end
  end
end
