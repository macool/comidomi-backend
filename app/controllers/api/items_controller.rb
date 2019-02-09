module Api
  class ItemsController < BaseController
    before_action :find_provider_category
    before_action :find_provider_profile
    before_action :find_provider_item
    before_action :pundit_authorize

    resource_description do
      name "Categories::Providers::Items"
      short "items from a provider"
    end

    api :GET,
        "/categories/:category_id/providers/:provider_id/items/:id",
        "Show a provider's item"
    param :id, Integer, required: true
    param :category_id, Integer, required: true
    param :provider_id, Integer, required: true
    see "provider-items#show", "provider::items#show for provider item in response"
    example %q{{
  "provider_item":{
    "id":1,
    "titulo":"Awesome Aluminum Bottle",
    "descripcion":"array uniforme Enfocado a benficios",
    "unidad_medida":"peso",
    "precio_cents":9533,
    "volumen":"768",
    "peso":"640 kg",
    "observaciones":"Seitan ramps williamsburg you probably haven't heard of them pitchfork intelligentsia hella.",
    "provider_item_category_id":1,
    "imagenes":[]
  }
}}
    def show
    end

    private

    def pundit_authorize
      authorize @provider_item, :read?
    end

    def find_provider_item
      provider_items_scope = ProviderItemPolicy::PublicScope.new(
        pundit_user,
        @provider_profile.provider_items
      ).resolve
      @provider_item = provider_items_scope.find(params[:id])
    end

    def find_provider_profile
      # TODO
      # probs this scope should be revised as well as parent's
      @provider_profile =
        @provider_item_category.provider_profiles
                               .find(params[:provider_id])
    end

    def find_provider_category
      @provider_item_category =
        policy_scope(ProviderCategory).find(params[:category_id])
    end
  end
end
