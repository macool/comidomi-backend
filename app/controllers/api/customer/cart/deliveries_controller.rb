module Api
  module Customer
    module Cart
      class DeliveriesController < Api::Customer::BaseController
        include Api::BaseController::Scopable
        include Api::BaseController::Resourceable

        before_action :authenticate_api_auth_user!

        self.resource_klass = CustomerOrderDelivery

        resource_description do
          name "Customer::Cart::Deliveries"
          short "current cart's deliveries"
          description "**NB.** this endpoint will render **full** customer order serialized in response as part of all actions"
        end

        api :PUT,
            "/customer/cart/deliveries/:id",
            "Update a delivery for current cart"
        param :id, Integer, required: true, desc: "customer order delivery id"
        param :provider_profile_id,
              Integer,
              required: true,
              desc: "the provider profile to whom this delivery will belong"
        param :delivery_method,
              CustomerOrderDelivery::DELIVERY_METHODS,
              required: true
        param :customer_address_id,
              Integer,
              desc: "the customer address for the delivery (**required if** method is `shipping`)"
        param :deliver_at,
              Time,
              desc: "a delivery may be scheduled"
        def update
          super
        end

        private

        def resource_template
          "api/customer/cart/customer_order"
        end

        def after_update_api_resource
          @customer_order = @api_resource.customer_order
        end
      end
    end
  end
end
