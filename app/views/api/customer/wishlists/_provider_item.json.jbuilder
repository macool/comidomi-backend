json.extract!(
  provider_item,
  :provider_profile_id
)

json.partial!(
  "api/providers/items/provider_item",
  provider_item: provider_item
)
