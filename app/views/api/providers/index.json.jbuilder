json.provider_category do
  # this template will call our local
  # _provider_profile partial
  # (api/providers/provider_profile)
  # which has complete information for
  # the provider profile
  json.partial! "api/categories/provider_category",
                provider_category: @provider_category

  json.provider_profiles do
    json.array!(
      visible_provider_profiles(@provider_category.provider_profiles),
      partial: "provider_profiles",
      as: :provider_profile
    )
  end
end
