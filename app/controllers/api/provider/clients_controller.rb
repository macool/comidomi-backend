module Api
  module Provider
    class ClientsController < Provider::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Provider::BaseController::ResourceCollectionable

      resource_description do
        name "Provider::Clients"
        short "provider's clients"
      end

      self.resource_klass = ProviderClient

      api :GET,
          "/provider/clients",
          "Lists provider's clients"
      example %q{{
  "provider_clients":[
    {
      "id":1,
      "notas":"jerarquía analizada Diverso",
      "ruc":"961770900-7",
      "nombres":"Urías S.A.",
      "direccion":"Subida Clemente Zapata, 9 Esc. 773",
      "telefono":"972 299 498",
      "email":"karelle@luettgenlueilwitz.name",
      "created_at":"2016-09-24T09:15:53.617-05:00"
    }
  ]
}}
      def index
        super
      end

      def_param_group :provider_client do
        param :notas, String
        param :ruc, String, required: true
        param :nombres, String, required: true
        param :direccion, String, required: true
        param :telefono, String, required: true
        param :email, String, required: true
      end

      api :POST,
          "/provider/clients",
          "Create a provider client"
      param_group :provider_client
      def create
        super
      end

      api :PUT,
          "/provider/clients/:id",
          "Update a provider's client"
      param :id,
            Integer,
            required: true,
            desc: "Provider client's id"
      param_group :provider_client
      def update
        super
      end

      api :DELETE,
          "/provider/clients/:id",
          "Delete a provider's client"
      desc "a soft delete is performed"
      param :id,
            Integer,
            required: true,
            desc: "Provider client's id"
      def destroy
        super
      end

      private

      def resource_destruction_method
        :soft_destroy
      end
    end
  end
end
