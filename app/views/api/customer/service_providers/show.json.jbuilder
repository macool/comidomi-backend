json.provider_profiles do
  json.array!(
    @api_collection,
    partial: "api/providers/provider_profiles",
    as: :provider_profile
  )
end
