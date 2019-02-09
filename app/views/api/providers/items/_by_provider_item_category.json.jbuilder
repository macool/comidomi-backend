json.partial!(
  "api/providers/item_categories/provider_item_category",
  provider_item_category: by_category[:provider_item_category]
)

json.provider_items do
  json.array!(
    by_category[:provider_items],
    partial: "api/providers/items/provider_item",
    as: :provider_item
  )
end
