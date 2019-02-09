json.provider_profile do
  ##
  # following partial is provider_profile's
  # public template
  json.partial!(
    "provider_profiles",
    provider_profile: @provider_profile
  )

  json.provider_item_categories do
    json.array!(
      @grouped_provider_items,
      partial: "api/providers/items/by_provider_item_category",
      as: :by_category
    )
  end
end
