json.provider_categories do
  json.array!(
    @provider_categories,
    partial: "provider_category_with_providers",
    as: :provider_category
  )
end
