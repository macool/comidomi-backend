module Api
  module Courier
    class ProfilesController < BaseController
      include Api::BaseController::Scopable
      include Api::BaseController::Resourceable

      resource_description do
        name "Courier::Profile"
        short "apply for a courier profile"
      end

      self.resource_klass = CourierProfile

      before_action :authenticate_api_auth_user!

      api :POST,
          "/courier/profile",
          "Submit a courier profile application. Response includes errors if any."
      see "users-places#index", "User::Places#index for available places"
      param :ruc, String, required: true
      param :email, String, required: true
      param :nombres, String, required: true
      param :telefono, String, required: true
      param :fecha_nacimiento, Date
      param :place_id,
            Integer,
            required: true,
            desc: "place id from the api"
      param :tipo_licencia,
            CourierProfile::TIPOS_LICENCIA
      param :tipo_medio_movilizacion, CourierProfile::TIPOS_MEDIO_MOVILIZACION
      example %q{{
  "courier_profile":{
    "id":1,
    "ruc":"1014736509",
    "email":"raina_lockman@schoen.io",
    "nombres":"Sr. María Cristina Pabón Mireles",
    "telefono":"988295716",
    "fecha_nacimiento":"1966-02-27",
    "ubicacion":"Loja",
    "tipo_licencia":"D1",
    "tipo_medio_movilizacion":"Bus pasajeros"
  }
}}
      def create
        super
      end
    end
  end
end
