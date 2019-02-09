json.provider_offices do
  json.array!(
    @api_collection,
    partial: "api/provider/offices/full_provider_office",
    as: :provider_office
  )
end
