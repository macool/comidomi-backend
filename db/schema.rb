# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190323062607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courier_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "nombres"
    t.string   "ruc"
    t.string   "telefono"
    t.string   "email"
    t.string   "tipo_medio_movilizacion"
    t.date     "fecha_nacimiento"
    t.string   "tipo_licencia"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "place_id",                                null: false
    t.boolean  "receive_calls",           default: false
    t.integer  "call_priority",           default: 0
  end

  add_index "courier_profiles", ["place_id"], name: "index_courier_profiles_on_place_id", using: :btree
  add_index "courier_profiles", ["receive_calls"], name: "index_courier_profiles_on_receive_calls", using: :btree
  add_index "courier_profiles", ["user_id"], name: "index_courier_profiles_on_user_id", using: :btree

  create_table "customer_addresses", force: :cascade do |t|
    t.string   "ciudad"
    t.string   "parroquia"
    t.string   "barrio"
    t.string   "direccion_uno"
    t.string   "direccion_dos"
    t.string   "codigo_postal"
    t.text     "referencia"
    t.string   "numero_convencional"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "customer_profile_id", null: false
    t.string   "nombre"
    t.string   "lat",                 null: false
    t.string   "lon",                 null: false
  end

  add_index "customer_addresses", ["customer_profile_id"], name: "index_customer_addresses_on_customer_profile_id", using: :btree

  create_table "customer_billing_addresses", force: :cascade do |t|
    t.integer  "customer_profile_id", null: false
    t.string   "ciudad"
    t.string   "telefono"
    t.string   "email"
    t.string   "ruc",                 null: false
    t.string   "razon_social",        null: false
    t.string   "direccion",           null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "customer_billing_addresses", ["customer_profile_id"], name: "index_customer_billing_addresses_on_customer_profile_id", using: :btree

  create_table "customer_errands", force: :cascade do |t|
    t.integer  "customer_profile_id",                          null: false
    t.integer  "place_id",                                     null: false
    t.text     "description",                                  null: false
    t.integer  "customer_address_id",                          null: false
    t.integer  "shipping_fare_price_cents",    default: 0,     null: false
    t.string   "shipping_fare_price_currency", default: "USD", null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "customer_errands", ["customer_address_id"], name: "index_customer_errands_on_customer_address_id", using: :btree
  add_index "customer_errands", ["customer_profile_id"], name: "index_customer_errands_on_customer_profile_id", using: :btree
  add_index "customer_errands", ["place_id"], name: "index_customer_errands_on_place_id", using: :btree

  create_table "customer_order_deliveries", force: :cascade do |t|
    t.datetime "deliver_at"
    t.string   "delivery_method",                               null: false
    t.integer  "customer_address_id"
    t.json     "customer_address_attributes"
    t.integer  "provider_profile_id"
    t.integer  "customer_order_id",                             null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "status",                      default: "draft", null: false
    t.text     "reason"
    t.integer  "shipping_fare_price_cents"
    t.integer  "preparation_time_mins"
    t.datetime "provider_responded_at"
    t.datetime "dispatch_at"
  end

  add_index "customer_order_deliveries", ["customer_address_id"], name: "index_customer_order_deliveries_on_customer_address_id", using: :btree
  add_index "customer_order_deliveries", ["customer_order_id"], name: "index_customer_order_deliveries_on_customer_order_id", using: :btree
  add_index "customer_order_deliveries", ["provider_profile_id"], name: "index_customer_order_deliveries_on_provider_profile_id", using: :btree
  add_index "customer_order_deliveries", ["status"], name: "index_customer_order_deliveries_on_status", using: :btree

  create_table "customer_order_items", force: :cascade do |t|
    t.integer  "customer_order_id",                             null: false
    t.integer  "provider_item_id",                              null: false
    t.integer  "provider_item_precio_cents"
    t.string   "provider_item_precio_currency", default: "USD", null: false
    t.integer  "cantidad",                      default: 1,     null: false
    t.text     "observaciones"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "customer_order_items", ["customer_order_id"], name: "index_customer_order_items_on_customer_order_id", using: :btree
  add_index "customer_order_items", ["provider_item_id"], name: "index_customer_order_items_on_provider_item_id", using: :btree

  create_table "customer_orders", force: :cascade do |t|
    t.string   "status",                              default: "in_progress", null: false
    t.integer  "subtotal_items_cents",                default: 0,             null: false
    t.string   "subtotal_items_currency",             default: "USD",         null: false
    t.integer  "customer_profile_id",                                         null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "forma_de_pago"
    t.text     "observaciones"
    t.text     "customer_billing_address_attributes"
    t.integer  "customer_billing_address_id"
    t.datetime "submitted_at"
    t.boolean  "anon_billing_address",                default: false
    t.integer  "place_id"
  end

  add_index "customer_orders", ["customer_billing_address_id"], name: "index_customer_orders_on_customer_billing_address_id", using: :btree
  add_index "customer_orders", ["customer_profile_id"], name: "index_customer_orders_on_customer_profile_id", using: :btree
  add_index "customer_orders", ["place_id"], name: "index_customer_orders_on_place_id", using: :btree
  add_index "customer_orders", ["status"], name: "index_customer_orders_on_status", using: :btree
  add_index "customer_orders", ["submitted_at"], name: "index_customer_orders_on_submitted_at", using: :btree

  create_table "customer_profiles", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customer_profiles", ["user_id"], name: "index_customer_profiles_on_user_id", using: :btree

  create_table "customer_wishlists", force: :cascade do |t|
    t.integer  "customer_profile_id",              null: false
    t.string   "nombre",                           null: false
    t.text     "provider_items_ids",  default: [],              array: true
    t.datetime "entregar_en"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "customer_wishlists", ["customer_profile_id"], name: "index_customer_wishlists_on_customer_profile_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "lat"
    t.string   "lon"
    t.string   "nombre",                              null: false
    t.string   "country",                             null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "price_per_km_cents",  default: 1
    t.float    "factor_per_distance", default: 0.1
    t.boolean  "enabled",             default: false
  end

  add_index "places", ["enabled"], name: "index_places_on_enabled", using: :btree
  add_index "places", ["nombre", "country"], name: "index_places_on_nombre_and_country", unique: true, using: :btree

  create_table "provider_categories", force: :cascade do |t|
    t.string   "titulo",                          null: false
    t.string   "imagen"
    t.text     "descripcion"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "status",      default: "enabled", null: false
  end

  add_index "provider_categories", ["status"], name: "index_provider_categories_on_status", using: :btree
  add_index "provider_categories", ["titulo"], name: "index_provider_categories_on_titulo", unique: true, using: :btree

  create_table "provider_clients", force: :cascade do |t|
    t.integer  "provider_profile_id"
    t.text     "notas"
    t.string   "ruc"
    t.string   "nombres"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "email"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "deleted_at"
  end

  add_index "provider_clients", ["deleted_at"], name: "index_provider_clients_on_deleted_at", using: :btree
  add_index "provider_clients", ["provider_profile_id"], name: "index_provider_clients_on_provider_profile_id", using: :btree

  create_table "provider_dispatchers", force: :cascade do |t|
    t.integer  "provider_office_id", null: false
    t.string   "email",              null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "deleted_at"
  end

  add_index "provider_dispatchers", ["deleted_at"], name: "index_provider_dispatchers_on_deleted_at", using: :btree
  add_index "provider_dispatchers", ["provider_office_id"], name: "index_provider_dispatchers_on_provider_office_id", using: :btree

  create_table "provider_item_categories", force: :cascade do |t|
    t.string   "nombre"
    t.boolean  "predeterminada",      default: false
    t.integer  "provider_profile_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "provider_item_categories", ["predeterminada"], name: "index_provider_item_categories_on_predeterminada", using: :btree
  add_index "provider_item_categories", ["provider_profile_id"], name: "index_provider_item_categories_on_provider_profile_id", using: :btree

  create_table "provider_item_images", force: :cascade do |t|
    t.integer  "provider_item_id", null: false
    t.string   "imagen",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "provider_item_images", ["provider_item_id"], name: "index_provider_item_images_on_provider_item_id", using: :btree

  create_table "provider_items", force: :cascade do |t|
    t.integer  "provider_profile_id"
    t.string   "titulo",                                    null: false
    t.text     "descripcion"
    t.integer  "unidad_medida"
    t.integer  "precio_cents",              default: 0,     null: false
    t.string   "precio_currency",           default: "USD", null: false
    t.string   "volumen"
    t.string   "peso"
    t.text     "observaciones"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "deleted_at"
    t.integer  "cantidad",                  default: 0
    t.boolean  "en_stock"
    t.integer  "provider_item_category_id"
    t.integer  "parent_provider_item_id"
    t.boolean  "is_group",                  default: false
  end

  add_index "provider_items", ["cantidad"], name: "index_provider_items_on_cantidad", using: :btree
  add_index "provider_items", ["deleted_at"], name: "index_provider_items_on_deleted_at", using: :btree
  add_index "provider_items", ["en_stock"], name: "index_provider_items_on_en_stock", using: :btree
  add_index "provider_items", ["is_group"], name: "index_provider_items_on_is_group", using: :btree
  add_index "provider_items", ["parent_provider_item_id"], name: "index_provider_items_on_parent_provider_item_id", using: :btree
  add_index "provider_items", ["provider_item_category_id"], name: "index_provider_items_on_provider_item_category_id", using: :btree
  add_index "provider_items", ["provider_profile_id"], name: "index_provider_items_on_provider_profile_id", using: :btree

  create_table "provider_office_weekdays", force: :cascade do |t|
    t.integer  "provider_office_id", null: false
    t.string   "day",                null: false
    t.boolean  "abierto"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "hora_de_apertura"
    t.datetime "hora_de_cierre"
  end

  add_index "provider_office_weekdays", ["provider_office_id"], name: "index_provider_office_weekdays_on_provider_office_id", using: :btree

  create_table "provider_offices", force: :cascade do |t|
    t.integer  "provider_profile_id",                 null: false
    t.boolean  "enabled",             default: false
    t.string   "direccion",                           null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "telefono"
    t.integer  "place_id"
    t.float    "lat",                                 null: false
    t.float    "lon",                                 null: false
  end

  add_index "provider_offices", ["enabled"], name: "index_provider_offices_on_enabled", using: :btree
  add_index "provider_offices", ["lat", "lon"], name: "index_provider_offices_on_lat_and_lon", using: :btree
  add_index "provider_offices", ["place_id"], name: "index_provider_offices_on_place_id", using: :btree
  add_index "provider_offices", ["provider_profile_id"], name: "index_provider_offices_on_provider_profile_id", using: :btree

  create_table "provider_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "ruc"
    t.string   "razon_social"
    t.string   "actividad_economica"
    t.string   "tipo_contribuyente"
    t.string   "representante_legal"
    t.string   "telefono"
    t.string   "email"
    t.date     "fecha_inicio_actividad"
    t.string   "banco_nombre"
    t.string   "banco_numero_cuenta"
    t.string   "website"
    t.string   "facebook_handle"
    t.string   "twitter_handle"
    t.string   "instagram_handle"
    t.string   "youtube_handle"
    t.text     "formas_de_pago",         default: [],              array: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "provider_category_id"
    t.string   "nombre_establecimiento",              null: false
    t.string   "logotipo"
    t.integer  "banco_tipo_cuenta"
    t.integer  "status",                 default: 0
  end

  add_index "provider_profiles", ["provider_category_id"], name: "index_provider_profiles_on_provider_category_id", using: :btree
  add_index "provider_profiles", ["status"], name: "index_provider_profiles_on_status", using: :btree
  add_index "provider_profiles", ["user_id"], name: "index_provider_profiles_on_user_id", using: :btree

  create_table "scheduled_courier_calls", force: :cascade do |t|
    t.integer  "customer_order_id",                   null: false
    t.text     "couriers_called_ids", default: [],                 array: true
    t.boolean  "done",                default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "scheduled_courier_calls", ["customer_order_id"], name: "index_scheduled_courier_calls_on_customer_order_id", using: :btree

  create_table "shipping_fares", force: :cascade do |t|
    t.integer  "place_id",                       null: false
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "shipping_fares", ["place_id"], name: "index_shipping_fares_on_place_id", using: :btree

  create_table "shipping_requests", force: :cascade do |t|
    t.integer  "resource_id",                         null: false
    t.string   "resource_type",                       null: false
    t.string   "kind",                                null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "status",              default: "new", null: false
    t.json     "address_attributes"
    t.integer  "courier_profile_id"
    t.string   "reason"
    t.integer  "place_id",                            null: false
    t.json     "waypoints"
    t.integer  "estimated_time_mins"
    t.datetime "assigned_at"
    t.float    "ref_lat",                             null: false
    t.float    "ref_lon",                             null: false
  end

  add_index "shipping_requests", ["courier_profile_id"], name: "index_shipping_requests_on_courier_profile_id", using: :btree
  add_index "shipping_requests", ["place_id"], name: "index_shipping_requests_on_place_id", using: :btree
  add_index "shipping_requests", ["ref_lat", "ref_lon"], name: "index_shipping_requests_on_ref_lat_and_ref_lon", using: :btree
  add_index "shipping_requests", ["resource_id", "resource_type"], name: "index_shipping_requests_on_resource_id_and_resource_type", using: :btree
  add_index "shipping_requests", ["status"], name: "index_shipping_requests_on_status", using: :btree

  create_table "site_preferences", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "site_preferences", ["name"], name: "index_site_preferences_on_name", unique: true, using: :btree

  create_table "user_devices", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "platform",   null: false
    t.string   "uuid",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_devices", ["platform", "uuid"], name: "index_user_devices_on_platform_and_uuid", using: :btree
  add_index "user_devices", ["user_id"], name: "index_user_devices_on_user_id", using: :btree

  create_table "user_locations", force: :cascade do |t|
    t.string   "lat",        null: false
    t.string   "lon",        null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
  end

  add_index "user_locations", ["user_id"], name: "index_user_locations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "info"
    t.json     "credentials"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "fecha_nacimiento"
    t.string   "ciudad"
    t.text     "privileges",             default: [],                   array: true
    t.string   "custom_image"
    t.boolean  "agreed_tos",             default: false
    t.integer  "current_place_id"
    t.string   "phone_number"
  end

  add_index "users", ["current_place_id"], name: "index_users_on_current_place_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.json     "object"
    t.datetime "created_at"
    t.json     "object_changes"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "courier_profiles", "places"
  add_foreign_key "courier_profiles", "users"
  add_foreign_key "customer_addresses", "customer_profiles"
  add_foreign_key "customer_billing_addresses", "customer_profiles"
  add_foreign_key "customer_errands", "customer_addresses"
  add_foreign_key "customer_errands", "customer_profiles"
  add_foreign_key "customer_errands", "places"
  add_foreign_key "customer_order_deliveries", "customer_addresses"
  add_foreign_key "customer_order_deliveries", "customer_orders"
  add_foreign_key "customer_order_deliveries", "provider_profiles"
  add_foreign_key "customer_order_items", "customer_orders"
  add_foreign_key "customer_order_items", "provider_items"
  add_foreign_key "customer_orders", "customer_billing_addresses"
  add_foreign_key "customer_orders", "customer_profiles"
  add_foreign_key "customer_orders", "places"
  add_foreign_key "customer_profiles", "users"
  add_foreign_key "customer_wishlists", "customer_profiles"
  add_foreign_key "provider_clients", "provider_profiles"
  add_foreign_key "provider_dispatchers", "provider_offices"
  add_foreign_key "provider_item_categories", "provider_profiles"
  add_foreign_key "provider_item_images", "provider_items"
  add_foreign_key "provider_items", "provider_item_categories"
  add_foreign_key "provider_items", "provider_items", column: "parent_provider_item_id"
  add_foreign_key "provider_items", "provider_profiles"
  add_foreign_key "provider_office_weekdays", "provider_offices"
  add_foreign_key "provider_offices", "places"
  add_foreign_key "provider_offices", "provider_profiles"
  add_foreign_key "provider_profiles", "provider_categories"
  add_foreign_key "provider_profiles", "users"
  add_foreign_key "scheduled_courier_calls", "customer_orders"
  add_foreign_key "shipping_fares", "places"
  add_foreign_key "shipping_requests", "courier_profiles"
  add_foreign_key "shipping_requests", "places"
  add_foreign_key "user_devices", "users"
  add_foreign_key "user_locations", "users"
  add_foreign_key "users", "places", column: "current_place_id"
end
