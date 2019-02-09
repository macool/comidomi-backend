module Admin
  class ProviderItemsController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "ProviderItem"

    def index
      pundit_authorize
      @resource_collection =
        resource_scope.includes(:imagenes,
                                :provider_profile,
                                :provider_item_category)
                      .page(params[:page])
                      .decorate
    end

    private

    def provider_item_search
      @provider_item_search ||= ProviderItemSearch.new(
        params[:provider_item_search] || {}
      )
    end
    helper_method :provider_item_search

    def resource_collection_for_scope
      provider_item_search.results
    end

    def provider_item_categories_for_select
      ProviderItemCategory.by_nombre
                          .decorate
                          .map do |provider_item_category|
        [ provider_item_category.to_s, provider_item_category.id ]
      end
    end
    helper_method :provider_item_categories_for_select

    def provider_profiles_for_select
      ProviderProfile.by_nombre
                     .decorate
                     .map do |provider_profile|
        [ provider_profile.to_s, provider_profile.id ]
      end
    end
    helper_method :provider_profiles_for_select
  end
end
