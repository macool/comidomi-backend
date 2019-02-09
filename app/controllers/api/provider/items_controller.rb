module Api
  module Provider
    class ItemsController < Provider::BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Provider::BaseController::ResourceCollectionable

      resource_description do
        name "Provider::Items"
        short "provider's items"
      end

      self.resource_klass = ProviderItem

      api :GET,
          "/provider/items",
          "Lists a provider's items"
      see "provider-items#show", "provider::items#show for provider item in response"
      desc "item's price is described in cents"
      example %q{{
  "provider_items":[
    {
      "id":1,
      "titulo":"Rustic Silk Pants",
      "descripcion":"data-warehouse 4th generación Orígenes",
      "unidad_medida":"volumen",
      "precio_cents":4079,
      "volumen":"798",
      "peso":"986 kg",
      "cantidad":"100",
      "en_stock":"true",
      "observaciones":"Marfa 90's xoxo shoreditch. Selvage butcher trust fund. Pickled polaroid echo hammock.\nKickstarter stumptown gastropub. Ramps chambray letterpress. Etsy ramps sustainable selfies tousled.\nPhoto booth loko chambray art party chillwave umami street tilde. Truffaut hammock knausgaard. Cronut messenger bag banh mi bushwick.",
      "created_at":"2016-08-17T17:21:04.569-05:00",
      "updated_at":"2016-08-17T17:21:04.569-05:00",
      "provider_item_category_id":1,
      "imagenes":[
        {
          "id":1,
          "imagen_url":"https://robohash.org/aliquamdelenitiquisquam.png?size=50x50&set=set1"
        }
      ]
    }
  ]
}}
      def index
        super
      end

      api :GET, "/provider/items:id", "get a provider's item"
      param :id, Integer, required: true
      example %q{{
  "provider_item":{
    "id":1,
    "titulo":"Ergonomic Granite Gloves",
    "descripcion":"utilización ejecutiva Pre-emptivo",
    "unidad_medida":"peso",
    "precio_cents":1196,
    "volumen":"653",
    "peso":"499 kg",
    "observaciones":"Fanny pack single-origin coffee schlitz sriracha tofu +1 chartreuse fashion axe.",
    "created_at":"2016-12-05T07:18:10.702-05:00",
    "updated_at":"2016-12-05T07:18:10.702-05:00",
    "imagenes":[
      {
        "id":1,
        "imagen_url":"https://robohash.org/aliquamdelenitiquisquam.png?size=50x50&set=set1"
      }
    ]
  }
}}
      def show
        super
      end

      def_param_group :provider_item do
        param :titulo, String, required: true
        param :descripcion, String
        param :precio, Float, required: true
        param :volumen, String
        param :peso, String
        param :cantidad, Integer, required: true
        param :en_stock, [true, false]
        param :imagenes_attributes,
              Hash,
              desc: "item images" do
          param :id,
                Integer,
                desc: "unique id for each image. Commonly used to update or destroy an image"
          param :imagen,
                File,
                required: true
          param :_destroy,
                TrueClass,
                desc: "to destroy the image with the given id"
        end
        param :observaciones, String
        param :unidad_medida,
              ProviderItem::UNIDADES_MEDIDA,
              "a string with one of the following: #{ProviderItem::UNIDADES_MEDIDA.join(", ")}"
      end

      api :POST,
          "/provider/items",
          "Create a provider item"
      param_group :provider_item
      def create
        new_api_resource
        build_provider_item_category
        super
      end

      api :PUT,
          "/provider/items/:id",
          "Update a provider's item"
      param :id,
            Integer,
            required: true,
            desc: "Provider item's id"
      param_group :provider_item
      def update
        find_api_resource
        build_provider_item_category
        super
      end

      api :DELETE,
          "/provider/items/:id",
          "Delete a provider's item"
      desc "soft delete is performed (no records are removed from DB)"
      param :id,
            Integer,
            required: true,
            desc: "Provider item's id"
      def destroy
        super
      end

      private

      def build_provider_item_category
        req_attributes = resource_params[:provider_item_category_attributes]
        if req_attributes.present?
          @api_resource.build_provider_item_category(
            req_attributes.merge(
              provider_profile: pundit_user.provider_profile
            )
          )
        end
      end

      def resource_destruction_method
        :soft_destroy
      end

      def resource_scope
        skip_policy_scope
        ProviderItemPolicy::ProviderScope.new(
          pundit_user, ProviderItem
        ).resolve
      end
    end
  end
end
