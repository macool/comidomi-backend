module Admin
  class CourierProfilesController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "CourierProfile"

    def index
      pundit_authorize
      @resource_status = "all"
      @resource_collection =
        resource_scope.send(@resource_status)
                      .page(params[:page]).per(9)
                      .decorate
    end

    def priorities
      pundit_authorize
      @resource_collection = resource_scope.by_priority.receive_calls.decorate
    end

    def new
      super
      if params[:user_id].present?
        user = User.find(params[:user_id])
        @current_resource.user = user
      elsif @current_resource.user.blank?
        @current_resource.build_user
      end
      @current_resource.assign_attributes(
        nombres: @current_resource.user.name
      )
    end

    def create
      super
    end

    private

    def users_for_select
      User.by_name.decorate.map do |user|
        [ "#{user.to_s} #{user.email}", user.id ]
      end
    end
    helper_method :users_for_select

    def courier_profile_places_for_select
      Place.sorted.decorate.map do |place|
        [ place.to_s, place.id ]
      end
    end
    helper_method :courier_profile_places_for_select

    def tipos_medios_movilizacion_for_select
      CourierProfile.tipo_medio_movilizacion.values.map do |tipo_medio|
        [ tipo_medio.titleize, tipo_medio ]
      end
    end
    helper_method :tipos_medios_movilizacion_for_select
  end
end
