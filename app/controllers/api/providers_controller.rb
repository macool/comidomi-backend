module Api
  class ProvidersController < BaseController
    include Api::BaseController::ProviderProfileScopable

    respond_to :json

    before_action :find_provider_category,
                  only: [:index, :show]
    before_action :pundit_authorize

    resource_description do
      name "Categories::Providers"
      short "providers from a category"
    end

    api :GET,
        "/categories/:category_id/providers",
        "List of providers that belong to a category"
    desc "includes full provider info"
    param :category_id, Integer, required: true
    example %q{{
  "provider_category":{
    "id":1,
    "titulo":"Tools",
    "imagen":"https://robohash.org/sapientesuntdelectus.png?size=400x600&set=set1",
    "descripcion":"Bushwick pug tote bag sriracha forage pinterest retro direct trade yr.",
    "provider_profiles":[
      {
        "id":1,
        "ruc":"3696402456",
        "razon_social":"Mendoza,
         Molina y Moreno Asociados",
        "nombre_establecimiento":"Almonte y Peralta",
        "actividad_economica":"advocate",
        "representante_legal":"Lorena Montenegro Cisneros",
        "telefono":"979-520-588",
        "email":"lora@andersonullrich.org",
        "website":"http://stamm.co/domenica.mante",
        "formas_de_pago":["efectivo"],
        "logotipo_url":null,
        "facebook_handle":"emilie",
        "twitter_handle":"billie",
        "instagram_handle":"nellie.douglas",
        "youtube_handle":"dennis",
        "provider_offices":[
          {
            "id":1,
            "direccion":"Caserio Marilu,
             6 Puerta 639",
            "ciudad":"Torrejón de Ardoz",
            "hora_de_apertura":"10:00 AM"
            "hora_de_cierre":"7:00 PM"
          }
        ]
      }
    ]
  }
}}
    def index
    end

    api :GET,
        "/categories/:category_id/providers/:id",
        "Show a provider with their products for offer"
    desc "includes full products info"
    param :category_id,
          Integer,
          required: true,
          desc: "category the provider belongs to"
    param :id,
          Integer,
          required: true,
          desc: "id of provider profile to display"
    example %q{{
  "provider_profile":{
    "id":1,
    "ruc":"4633376839",
    "razon_social":"Cortez S.A.",
    "nombre_establecimiento":"Casillas S.L.",
    "actividad_economica":"designer",
    "representante_legal":"Sancho Nevárez Peralta",
    "telefono":"989-439-488",
    "email":"brianne@huel.io",
    "website":"http://torphartmann.biz/giles_little",
    "formas_de_pago":["efectivo"],
    "logotipo_url":null,
    "facebook_handle":"gaetano_damore",
    "twitter_handle":"grace_zulauf",
    "instagram_handle":"reva_hermann",
    "youtube_handle":"dewitt_rodriguez",
    "provider_offices":[{
      "id":1,
      "direccion":"Municipio Guadalupe 84 Puerta 392",
      "ciudad":"Fuenlabrada",
      "hora_de_apertura":"10:00 AM"
      "hora_de_cierre":"7:00 PM"
    }],
    "provider_item_categories":[{
      "id":2,
      "nombre":"Grocery, Tools \u0026 Computers",
      "provider_items":[{
        "id":1,
        "titulo":"Small Copper Bag",
        "descripcion":"contingencia valor añadido Organizado",
        "unidad_medida":"longitud",
        "precio_cents":3068,
        "volumen":"319",
        "peso":"911 kg",
        "observaciones":"Neutra cred schlitz vice try-hard. Twee deep v beard poutine. Actually listicle vinyl.\nGastropub locavore tacos mustache occupy typewriter church-key pour-over. Tacos bitters pour-over master pinterest. Synth yr yolo chillwave fanny pack freegan. Salvia selvage kitsch literally fanny pack.\nMaster cardigan fanny pack. Fanny pack venmo locavore brunch lomo leggings. Craft beer franzen 3 wolf moon.",
        "imagenes":[{
          "id":1,
          "imagen_url":"https://robohash.org/entesuntdelectus.png?size=400x600&set=set1"
        }]
      }]
    ]}
  }
}}
    def show
      @provider_profile = get_provider_profile
      @grouped_provider_items = get_grouped_provider_items
    end

    private

    def provider_profiles_scope
      visible_provider_profiles(@provider_category.provider_profiles)
    end

    def get_provider_profile
      provider_profiles_scope.find(params[:id])
    end

    def get_grouped_provider_items
      @provider_profile.provider_items_by_categories(
        provider_items_scope.includes(:provider_item_category)
      )
    end

    def provider_items_scope
      ProviderItemPolicy::PublicScope.new(
        pundit_user,
        @provider_profile.provider_items
      ).resolve
    end

    def pundit_authorize
      authorize ProviderCategory
    end

    def provider_category_scope
      policy_scope(ProviderCategory)
    end

    def find_provider_category
      @provider_category = provider_category_scope.find(params[:category_id])
    end
  end
end
