module Api
  module Customer
    class BillingAddressesController < Customer::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Customer::BaseController::ResourceCollectionable

      resource_description do
        name "Customer::BillingAddresses"
        short "customer's billing addresses"
      end

      self.resource_klass = CustomerBillingAddress

      before_action :authenticate_api_auth_user!
      before_action :find_or_create_customer_profile,
                    except: :index

      api :GET,
          "/customer/billing_addresses",
          "customer billing addresses"
      example %q{{
  "customer_billing_addresses":[
    {
      "id":1,
      "ruc":"2769097354745",
      "email":"jamel@breitenberghamill.io",
      "ciudad":"Segovia",
      "telefono":"934 476 388",
      "direccion":"Mercado Juan,43 Esc. 798",
      "razon_social":"Alonso, Noriega y Paredes Asociados"
    }
  ]
}}
      def index
        super
      end

      api :GET,
          "/customer/billing_addresses/:id",
          "show a customer's billing address"
      param :id, Integer, required: true, desc: "unique billing address id"
      see "customer-billing_addresses#index", "Customer::BillingAddresses#index for response serialization"
      def show
        super
      end

      def_param_group :customer_billing_address do
        param :ruc, String, required: true
        param :email, String
        param :ciudad, String
        param :telefono, String
        param :razon_social, String, required: true
      end

      api :POST,
          "/customer/billing_addresses",
          "Create a customer's billing address"
      param_group :customer_billing_address
      def create
        super
      end

      api :PUT,
          "/customer/billing_addresses/:id",
          "Update a customer's billing address"
      param :id, Integer, required: true
      param_group :customer_billing_address
      def update
        super
      end
    end
  end
end
