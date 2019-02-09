module Api
  module Customer
    class WishlistsController < BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable
      include Api::Customer::BaseController::ResourceCollectionable

      before_action :authenticate_api_auth_user!
      before_action :find_or_create_customer_profile,
                    except: :index

      self.resource_klass = CustomerWishlist

      resource_description do
        name "Customer::Wishlists"
        short "current customer's wishlists"
      end

      api :GET,
          "/customer/wishlists",
          "customer wishlists. response sideloads public provider profiles and provider items"
      example %q{{
  "customer_wishlists":[
    {
      "id":4,
      "nombre":"90's meditation farm-to-table.",
      "entregar_en":"2016-11-06 20:02 -0500",
      "provider_items":[
        {
          "provider_profile_id":2,
          "id":2,
          "titulo":"Intelligent Marble Shirt",
          "descripcion":"contingencia 4th generación Progresivo",
          "unidad_medida":"peso",
          "precio_cents":1889,
          "volumen":"428",
          "peso":"693 kg",
          "observaciones":"Next level narwhal gluten-free heirloom. Master small batch drinking ethical kogi cred helvetica. Fap lomo polaroid. Keffiyeh poutine heirloom bespoke.\nYou probably haven't heard of them gentrify retro fap. Chambray street chartreuse meditation cornhole brunch slow-carb keffiyeh. Cold-pressed keffiyeh try-hard. Twee retro lumbersexual loko poutine food truck sartorial freegan.",
          "imagenes":[]
        }
      ]
    }
  ],
  "provider_profiles":[
    {
      "provider_category_id":2,
      "id":2,
      "ruc":"0642772833",
      "razon_social":"Maldonado, Nieto y Barrera Asociados",
      "nombre_establecimiento":"Carrion Hermanos",
      "actividad_economica":"agriculturist",
      "representante_legal":"Rafael Sáenz Osorio",
      "telefono":"996.620.499",
      "email":"axel@halvorson.com",
      "website":"http://lynch.org/vaughn.hilll",
      "formas_de_pago":["tarjeta_credito"],
      "logotipo_url":null,
      "facebook_handle":"pink.williamson",
      "twitter_handle":"diana",
      "instagram_handle":"leanna_mclaughlin",
      "youtube_handle":"rosamond.miller"
    }
  ]
}
      }
      def index
        super
        if @api_collection.present?
          @provider_profiles = get_provider_profiles(
            @api_collection.map(&:provider_items).flatten
          )
        end
      end

      def_param_group :customer_wishlist do
        param :nombre,
              String,
              required: true,
              desc: "Nombre para identificar la lista"
        param :entregar_en,
              Time,
              "Permite especificar al cliente la fecha y hora de entrega deseada"
        param :provider_items_ids,
              Array,
              "Arreglo con los ítems que pertenecen a la lista"
      end

      api :POST,
          "/customer/wishlists",
          "create a wishlist"
      param_group :customer_wishlist
      def create
        super
      end

      api :PUT,
          "/customer/wishlists/:id",
          "update a wishlist"
      param :id,
            Integer,
            required: true,
            desc: "customer wishlist's id"
      param_group :customer_wishlist
      def update
        super
      end

      api :DELETE,
          "/customer/wishlists/:id",
          "destroy a wishlist"
      param :id,
            Integer,
            required: true,
            desc: "wishlist's id"
      def destroy
        super
      end

      private

      def after_create_api_resource
        sideload_provider_profiles
      end

      def after_update_api_resource
        sideload_provider_profiles
      end

      def sideload_provider_profiles
        @provider_profiles = get_provider_profiles(
          @api_resource.provider_items
        )
      end

      def get_provider_profiles(provider_items)
        # is this too much for the controller?
        # could probably be avoided by adding a
        # proper relationship
        provider_profile_ids = provider_items.map(&:provider_profile_id)
        ProviderProfile.where(
          id: provider_profile_ids
        )
      end
    end
  end
end
