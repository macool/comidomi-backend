module Api
  module Provider
    class ItemCategoriesController < Provider::BaseController
      include Api::BaseController::Scopable
      include Api::Provider::BaseController::ResourceCollectionable

      resource_description do
        name "Provider::ItemCategories"
        short "provider item categories"
      end

      self.resource_klass = ProviderItemCategory

      api :GET,
          "/provider/item_categories",
          "Lists categories available for a provider"
      param :q,
            String,
            desc: "Used to filter relevant provider item categories"
      desc "`personal` means this category is available only for this provider. `predeterminada` is the default category used for provider items"
      example %q{{
  "provider_item_categories":[
    {
      "id":1,
      "nombre":"Games \u0026 Baby",
      "personal":false,
      "predeterminada":true
    },
    {
      "id":2,
      "nombre":"Clothing",
      "personal":true,
      "predeterminada":false
    }
  ]
}}
      def index
        super
        if params[:q].present?
          @api_collection = @api_collection.nombre_like(params[:q])
          @api_collection = @api_collection.page(1)
        end
      end
    end
  end
end
