json.provider_item_categories do
  json.array!(
    @api_collection,
    partial: "item_category",
    as: :provider_item_category
  )
end
