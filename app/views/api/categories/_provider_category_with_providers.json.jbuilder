json.partial!(
  "provider_category",
  provider_category: provider_category
)

##
# in this endpoint we probably don't need
# to send complete provider's profile
# either. Could use a
# _simplified_provider_profile template
# instead (?)
json.provider_profiles do
  json.array!(
    visible_provider_profiles(provider_category.provider_profiles),
    partial: "api/providers/provider_profile",
    as: :provider_profile
  )
end
