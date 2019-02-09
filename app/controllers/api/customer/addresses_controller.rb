module Api
  module Customer
    class AddressesController < Customer::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Customer::BaseController::ResourceCollectionable

      resource_description do
        name "Customer::Addresses"
        short "customer's address"
      end

      self.resource_klass = CustomerAddress

      before_action :authenticate_api_auth_user!
      before_action :find_or_create_customer_profile,
                    except: :index

      api :GET,
          "/customer/addresses",
          "customer addresses"
      example %q{{
  "customer_addresses":[
    {
      "id":1,
      "nombre":"Departamento",
      "ciudad":"Quito",
      "parroquia":"Quito",
      "barrio":"Cumbayá",
      "direccion_uno":"Calle Miguel Ángel",
      "direccion_dos":"Lorem Impusm",
      "codigo_postal":"124455",
      "numero_convencional":"2342-5678",
      "referencia":"Cerca a la cuchara, casa de 2 pisos amarilla"
    }
  ]}
}
      def index
        super
        if @api_collection.present?
          @api_collection = @api_collection.decorate
        end
      end

      api :GET,
          "/customer/addresses/:id",
          "show a customer's delivery address"
      param :id, Integer, required: true, desc: "unique address id"
      see "customer-addresses#index", "Customer::Addresses#index for resource serialization in response"
      def show
        super
      end

      def_param_group :customer_address do
        param :nombre, String
        param :ciudad, String
        param :parroquia, String
        param :barrio, String
        param :direccion_uno, String
        param :direccion_dos, String
        param :codigo_postal, String
        param :referencia, String
        param :numero_convencional, String
      end

      api :POST,
          "/customer/addresses",
          "Create customer's address"
      param_group :customer_address
      def create
        super
      end

      api :PUT,
          "/customer/addresses/:id",
          "Edit customer's address"
      param :id, Integer, required: true
      param_group :customer_address
      def update
        super
      end
    end
  end
end
