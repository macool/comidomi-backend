module Api
  class CategoriesController < BaseController
    include Api::BaseController::ProviderProfileScopable

    respond_to :json

    resource_description do
      short "provider categories"
    end

    api :GET,
        "/categories",
        "List provider categories including a simple list of their providers"
    example %q{{
  "provider_categories":[
    {
      "id":1,
      "titulo":"Alimentos preparados",
      "imagen":"https://robohash.org/admaioresvoluptatem.png?size=400x600&set=set1",
      "descripcion":"Cold-pressed you probably haven't heard of them quinoa blue bottle.",
      "provider_profiles":[
        {
          "id":1,
          "ruc":"8358050460",
          "razon_social":"Garay, Lucio y Tovar Asociados",
          "nombre_establecimiento":"Salcido, Mejía y Olivas Asociados",
          "actividad_economica":"agriculturist",
          "representante_legal":"Rebeca Mateo Borrego",
          "telefono":"976911452",
          "email":"marcos@tromp.info",
          "website":"http://price.io/helga",
          "formas_de_pago":["efectivo"],
          "logotipo_url":null,
          "facebook_handle":"heather",
          "twitter_handle":"clay_mann",
          "instagram_handle":"jamel",
          "youtube_handle":"haan.gibson"
        }
      ]
    }
  ]
}}
    def index
      authorize ProviderCategory
      @provider_categories = public_scope.by_titulo
                                         .includes(:provider_profiles)
    end

    private

    def public_scope
      policy_scope(ProviderCategory)
    end
  end
end
