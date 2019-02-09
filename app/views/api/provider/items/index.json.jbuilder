json.provider_items do
  json.array!(
    @api_collection,
    partial: "item",
    as: :provider_item
  )
end
