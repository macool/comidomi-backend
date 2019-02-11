module Api
  module Courier
    class ShippingRequestsController < BaseController
      resource_description do
        name "Courier::ShippingRequests"
        short "shipping requests available for couriers"
      end

      before_action :authenticate_api_auth_user!

      api :GET,
          "/courier/shipping_requests",
          "Shipping requests available for courier"
      description "`kind_text` is the localized value for `kind`"
      see "providers#index", "Categories::Providers#index for provider_profile serialization in response"
      param :status,
            ShippingRequest.status.values,
            required: true,
            desc: "shipping requests' status"
      example %q{{
  "shipping_requests":
    [{
      "id":1,
      "kind":"ask_to_validate",
      "kind_text":"Validar proveedor",
      "status":"new",
      "status_text":"Nuevo",
      "estimated_time_mins":35,
      "address_attributes": {"direccion":"Calle Miguel Ángel"},
      "provider_profile": {...}
    }]
}}
      def index
        authorize ShippingRequest
        @api_collection =
          resource_scope
            .with_status(params[:status])
            .for_place(pundit_user.courier_profile.place)
            .latest
      end

      api :GET,
          "/courier/shipping_requests/myself",
          "Shipping requests assigned to current courier"
      description "`kind_text` is the localized value for `kind`"
      see "providers#index", "Categories::Providers#index for provider_profile serialization in response"
      param :status,
            ShippingRequest.status.values,
            desc: "shipping requests' status"
      example %q{{
  "shipping_requests":
    [{
      "id":1,
      "kind":"ask_to_validate",
      "kind_text":"Validar proveedor",
      "status":"new",
      "status_text":"Nuevo",
      "estimated_time_mins":35,
      "address_attributes": {"direccion":"Calle Miguel Ángel"},
      "provider_profile": {...}
    }]
}}
      def myself
        authorize ShippingRequest
        @api_collection =
          resource_scope
            .for_courier(pundit_user.courier_profile)
            .latest
        if params[:status].present?
          @api_collection = @api_collection.with_status(params[:status])
        end
      end

      api :GET,
          "/courier/shipping_requests/:id",
          "Show a shipping request"
      see "courier-shipping_requests#index", "Courier::ShippingRequests#index for response serialization"
      param :id, Integer, required: true
      def show
        authorize ShippingRequest
        @api_resource = resource_scope.find params[:id]
      end

      api :POST,
          "/courier/shipping_requests/:id/take",
          "Take a shipping request"
      see "courier-shipping_requests#index", "Courier::ShippingRequests#index for response serialization"
      param :id, Integer, required: true
      param :estimated_time_mins,
            Integer,
            required: true,
            desc: "Estimated time in minutes"
      def take
        @api_resource = resource_scope.find params[:id]
        authorize @api_resource
        ShippingRequest::TakeService.new(
          shipping_request: @api_resource,
          courier_profile: pundit_user.courier_profile,
          estimated_time_mins: params[:estimated_time_mins]
        ).perform!
        render :show
      end

      api :POST,
          "/courier/shipping_requests/:id/in_store",
          "A courier says he is in the store. updates status"
      see "courier-shipping_requests#index", "Courier::ShippingRequests#index for response serialization"
      param :id, Integer, required: true
      def in_store
        @api_resource = resource_scope.find params[:id]
        authorize @api_resource
        ShippingRequest::InStoreService.new(
          shipping_request: @api_resource,
          courier_profile: pundit_user.courier_profile
        ).perform!
        render :show
      end

      api :POST,
          "/courier/shipping_requests/:id/delivered",
          "the shipping request has been delivered"
      see "courier-shipping_requests#index", "Courier::ShippingRequests#index for response serialization"
      param :id, Integer, required: true
      def delivered
        @api_resource = resource_scope.find params[:id]
        authorize @api_resource
        ShippingRequest::DeliveredService.new(
          shipping_request: @api_resource,
          courier_profile: pundit_user.courier_profile
        ).perform!
        render :show
      end

      private

      def resource_scope
        policy_scope(ShippingRequest)
      end
    end
  end
end
