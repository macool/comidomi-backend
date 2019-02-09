module Api
  module Customer
    module Cart
      class ItemsController < Api::Customer::BaseController
        include Api::BaseController::Scopable
        include Api::BaseController::Resourceable

        before_action :authenticate_api_auth_user!
        before_action :find_or_create_customer_profile,
                      except: :index
        before_action :find_or_create_current_order,
                      except: :index

        self.resource_klass = CustomerOrderItem

        resource_description do
          name "Customer::Cart::Items"
          short "current customer's items in cart"
          description "**NB.** this endpoint will render **full** customer order serialized in response as part of all actions"
        end

        api :GET,
            "/customer/cart",
            "Get current cart"
        desc %q{
Returns current customer order or empty if there's no customer order.

Each order item has a cached price which should be used as provider's item may change it's price.

Customer order items are grouped by the provider who offers them.

`shipping_fare_price_cents` from `customer_order_delivery` is calculated if delivery method is shipping
}
        example %q{{
  "customer_order":{
    "id":1,
    "status":"in_progress",
    "observaciones":"something",
    "forma_de_pago":"efectivo",
    "delivery_method":"shipping",
    "subtotal_items_cents":44811,
    "customer_address_id":1,
    "customer_billing_address_id":2,
    "provider_profiles":[{
      "id":1,
      "ruc":"6938433417",
      "status":"applied",
      "razon_social":"Suárez, Grijalva y Méndez Asociados",
      "nombre_establecimiento":"Meza y Ochoa",
      "actividad_economica":"librarian",
      "representante_legal":"Sr. María Teresa Garica Saiz",
      "telefono":"967273751",
      "email":"duncan@bruentorphy.com",
      "website":"http://koelpin.com/myrl.greenholt",
      "formas_de_pago":["tarjeta_credito"],
      "logotipo_url":null,
      "facebook_handle":"faustino",
      "twitter_handle":"renee",
      "instagram_handle":"foster",
      "youtube_handle":"isac.metz",
      "customer_order_delivery":{
        "id":2,
        "delivery_method":"shipping",
        "customer_address_id":1,
        "shipping_fare_price_cents":150,
        "deliver_at":"2016-12-21 19:22 -0500"
      },
      "customer_order_items":[{
        "id":1,
        "cantidad":7,
        "observaciones":"Wolf offal drinking taxidermy tousled farm-to-table. Distillery fixie sustainable small batch wayfarers paleo.",
        "provider_item_precio_cents":6585,
        "provider_item":{
          "id":1,
          "titulo":"Durable Granite Car",
          "descripcion":"Soporte orientada a soluciones Versatil",
          "unidad_medida":"peso",
          "precio_cents":6585,
          "volumen":"530",
          "peso":"660 kg",
          "observaciones":"Forage small batch you probably haven't heard of them.",
          "imagenes":[]
        }
      }]
    }]
  }
}}
        def index
          pundit_authorize
          @customer_profile = current_api_auth_user.customer_profile
          if @customer_profile.present?
            @customer_order = @customer_profile.current_order
          end
          skip_policy_scope # because we access through #current_order
          render resource_template
        end

        def_param_group :customer_order_item do
          param :cantidad,
                Integer,
                required: true,
                desc: "Cantidad de ítems a agregar al carrito"
          param :observaciones,
                String,
                desc: "Observaciones para el ítem. ej: sin cebolla"
        end

        api :POST,
            "/customer/cart/items",
            "Add an item to the cart"
        see "customer-cart-items#index", "Customer::Cart::Items#index for customer order serialization in response"
        param :provider_item_id,
              Integer,
              required: true,
              desc: "Ítem a agregar al carrito"
        param_group :customer_order_item
        def create
          super
        end

        api :PUT,
            "/customer/cart/items/:id",
            "Update an item in the cart"
        see "customer-cart-items#index", "Customer::Cart::Items#index for customer order serialization in response"
        param :id,
              Integer,
              required: true,
              desc: "order item's id"
        param_group :customer_order_item
        def update
          super
        end

        api :DELETE,
            "/customer/cart/items/:id",
            "Remove an item from the cart"
        see "customer-cart-items#index", "Customer::Cart::Items#index for customer order serialization in response"
        param :id,
              Integer,
              required: true,
              desc: "order item's id"
        def destroy
          super
        end

        private

        def resource_destruction_response
          render resource_template, status: :accepted
        end

        def after_update_api_resource
          # HACK force resetting @customer_order
          # as it's left stale because of caches and so
          @customer_order = @api_resource.customer_order
        end

        def resource_template
          "api/customer/cart/customer_order"
        end

        def new_api_resource
          @api_resource = existing_order_item.presence || new_order_item
        end

        def existing_order_item
          @customer_order.order_items.find_by(
            provider_item_id: params[:provider_item_id].to_i
          ).tap do |api_resource|
            if api_resource.present?
              api_resource.readd_from_attributes resource_params
            end
          end
        end

        def new_order_item
          @customer_order.order_items.new(resource_params)
        end

        def find_api_resource
          @api_resource =
            @customer_order.order_items.find(params[:id])
        end

        def find_or_create_current_order
          skip_policy_scope # because we access through #current_order
          @customer_order = @customer_profile.current_order_or_create_for(
            pundit_user.current_place
          )
        end
      end
    end
  end
end
