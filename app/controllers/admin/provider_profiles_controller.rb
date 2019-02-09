module Admin
  class ProviderProfilesController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "ProviderProfile"

    before_action :find_current_resource, only: :transition
    before_action :pundit_authorize, only: :transition

    def index
      pundit_authorize
      @resource_status = params[:status] || :active
      @resource_collection =
        resource_scope.with_status(@resource_status)
                      .includes(:provider_category)
                      .page(params[:page]).per(9)
                      .decorate
    end

    def show
      super
    end

    def new
      super
      build_one_office
      office_belongs_to_place
      build_offices_weekdays
    end

    def edit
      super
      build_one_office
      office_belongs_to_place
      build_offices_weekdays
    end

    def update
      super
    end

    def transition
      transitor = transitor_service(params[:predicate]).perform!
      redirect_to(
        { action: :show, id: params[:id] },
        transitor.flashes
      )
    end

    private

    def office_belongs_to_place
      office = @current_resource.offices.object.first
      if office.place.blank?
        office.place = Place.first
      end
    end

    def build_one_office
      @current_resource.offices.object.build if @current_resource.offices.length == 0
    end

    def build_offices_weekdays
      @current_resource.object.offices.each do |office|
        if office.weekdays.length == 0
          office.build_weekdays
        end
      end
    end

    def transitor_service(predicate)
      ProviderProfile::TransitorService.new(
        @current_resource,
        predicate
      )
    end
    helper_method :transitor_service

    def provider_categories_for_select
      ProviderCategory.by_titulo
                      .decorate
                      .map do |provider_category|
        [ provider_category.to_s, provider_category.id ]
      end
    end
    helper_method :provider_categories_for_select

    def provider_office_places_for_select
      Place.sorted.decorate.map do |place|
        [ place.to_s, place.id ]
      end
    end
    helper_method :provider_office_places_for_select
  end
end
