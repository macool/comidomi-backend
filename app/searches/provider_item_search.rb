require "searchlight/adapters/action_view"

class ProviderItemSearch < ResourceSearch
  include Searchlight::Adapters::ActionView

  def base_query
    ProviderItem.all
  end

  def search_provider_profile_ids
    query.where(provider_profile_id: provider_profile_ids)
  end

  def search_provider_item_category_ids
    query.where(provider_item_category_id: provider_item_category_ids)
  end

  def search_titulo
    query.where("titulo ILIKE :titulo", titulo: "%#{titulo}%")
  end
end
