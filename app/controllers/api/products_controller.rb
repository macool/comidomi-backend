module Api
  class ProductsController < BaseController
    before_action :authenticate_api_auth_user!

    respond_to :json

    api :GET,
        "/products",
        "Public products. DEPRECATED. products should be accessed via Categories::Providers#show endpoint",
        deprecated: true
    desc "Up to #{Kaminari.config.default_per_page} products per page. Supports pagination"
    param :page, Integer
    example %q{{
  "products" : [
    {
      "id":2,
      "titulo":"Fantastic Wooden Bench",
      "descripcion":"moderador local Public-key",
      "unidad_medida":"longitud",
      "precio_cents":209,
      "volumen":"948",
      "peso":"978 kg",
      "observaciones":"Loko pop-up narwhal blue bottle. Tumblr drinking single-origin coffee. Mumblecore crucifix beard kinfolk heirloom hammock yolo. Trust fund intelligentsia biodiesel listicle waistcoat skateboard kombucha.\nStumptown sriracha literally. Food truck thundercats stumptown celiac meggings mixtape kickstarter. 8-bit pinterest pabst blog. Aesthetic single-origin coffee kale chips.\nMarfa blue bottle portland. Fap knausgaard stumptown dreamcatcher. Synth etsy kombucha next level dreamcatcher. Tousled sartorial cornhole butcher.",
      "created_at":"2016-08-22T07:52:05.536-05:00",
      "updated_at":"2016-08-22T07:52:05.536-05:00",
      "imagenes": [
        {
          "id": 1,
          "imagen_url":"https://robohash.org/laborepraesentiumimpedit.png?size=50x50&set=set1"
        }
      ]
    }
  ],
  "meta" : {
    "total_pages": 1
  }
}}
    def index
      skip_authorization # REMOVE this endpoint
      @products = public_scope.page(params[:page])
    end

    private

    def public_scope
      skip_policy_scope # calling PublicScope won't save us
      ProviderItemPolicy::PublicScope.new(
        pundit_user, ProviderItem
      ).resolve
    end
  end
end
