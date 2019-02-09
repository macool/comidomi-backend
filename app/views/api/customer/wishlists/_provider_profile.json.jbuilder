json.extract!(
  provider_profile,
  :provider_category_id
)

json.partial!(
  "api/providers/provider_profile",
  provider_profile: provider_profile
)
