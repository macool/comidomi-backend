module Api
  module Provider
    class DispatchersController < Provider::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Provider::BaseController::ResourceCollectionable

      resource_description do
        name "Provider::Dispatchers"
        short "provider's dispatchers"
      end

      self.resource_klass = ProviderDispatcher

      before_action :find_provider_office,
                    only: [:create, :update]

      api :GET,
          "/provider/dispatchers",
          "Lists provider's dispatchers"
      see "provider-dispatchers#show", "Provider::Dispatchers#show for full dispatcher response"
      description "**NB** provider dispatcher in response doesn't include provider office as the rest of endpoints. It only includes the provider office id instead."
      example %q{{
        "provider_dispatchers":[
          {
            "provider_dispatcher": {
              "id":5,
              "email":"daron.gulgowski@ebertraynor.org",
              "provider_office_id":5,
              "user":{
                "id":7,
                "to_s":"Beatriz Soto Valles",
                "image_url":"https://robohash.org/architectoanimiquos.png?size=300x300&set=set1"
              }
            }
          }
        ]
      }}
      def index
        super
      end

      api :GET,
          "/provider/dispatchers/:id",
          "Get a provider's dispatcher"
      description "Includes provider office in response. Includes user in response if exists"
      param :id, Integer, required: true
      see "provider-offices#index", "Provider::Offices#index for provider_office serialization in response"
      example %q{
  "provider_dispatcher": {
    "id":5,
    "email":"daron.gulgowski@ebertraynor.org",
    "provider_office_id":5,
    "user":{
      "id":7,
      "to_s":"Beatriz Soto Valles",
      "image":"https://robohash.org/architectoanimiquos.png?size=300x300&set=set1"
    },
    "provider_office":{}
  }
}
      def show
        super
      end

      def_param_group :provider_dispatcher do
        param :email, String, required: true
        param :provider_office_id, Integer, required: true
      end

      api :POST,
          "/provider/dispatchers",
          "Create a provider dispatcher"
      see "provider-dispatchers#show", "Provider::Dispatchers#show for full dispatcher response"
      param_group :provider_dispatcher
      def create
        super
      end

      api :PUT,
          "/provider/dispatchers/:id",
          "Update a provider's dispatcher"
      see "provider-dispatchers#show", "Provider::Dispatchers#show for full dispatcher response"
      param :id,
            Integer,
            required: true,
            desc: "Provider dispatcher's id"
      param_group :provider_dispatcher
      def update
        super
      end

      api :DELETE,
          "/provider/dispatchers/:id",
          "Delete a provider's dispatcher"
      desc "a soft delete is performed"
      param :id,
            Integer,
            required: true,
            desc: "Provider dispatcher's id"
      def destroy
        super
      end

      private

      def resource_destruction_method
        :soft_destroy
      end

      def new_api_resource
        @api_resource = @provider_office.provider_dispatchers.new(resource_params)
      end

      def find_provider_office
        @provider_office = policy_scope(ProviderOffice).find(
          params[:provider_office_id]
        ) if params[:provider_office_id].present?
      rescue ActiveRecord::RecordNotFound
        # means provider office is not within
        # provider's scope
        raise Pundit::NotAuthorizedError
      end
    end
  end
end
