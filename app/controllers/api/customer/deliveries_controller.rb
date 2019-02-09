module Api
  module Customer
    class DeliveriesController < BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable

      resource_description do
        name "Customer::Deliveries"
        short "manage customer deliveries"
      end

      self.resource_klass = CustomerOrderDelivery

      before_action :authenticate_api_auth_user!

      api :POST,
          "/customer/orders/:order_id/deliveries/:id/cancel",
          "cancel a delivery"
      param :order_id,
            Integer,
            required: true,
            desc: "order to which the delivery belongs to"
      param :id,
            Integer,
            required: true,
            desc: "delivery to cancel"
      def cancel
        @api_resource = get_customer_order_delivery
        pundit_authorize_resource
        if cancelation.perform
          render resource_template, status: :created
        else
          render_resource_error
        end
      end

      private

      def cancelation
        CustomerOrderDelivery::CancelService.new(
          @api_resource
        )
      end

      def get_customer_order_delivery
        order = policy_scope(CustomerOrder).find(
          params[:order_id]
        )
        order.deliveries.find(params[:id])
      end
    end
  end
end
