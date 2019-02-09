json.provider_profile do
  json.partial!(
    "api/providers/provider_profile",
    provider_profile: @api_resource
  )
  json.partial!(
    "api/providers/private_provider_profile",
    provider_profile: @api_resource
  )

  json.provider_offices do
    json.array!(
      @api_resource.offices,
      partial: "api/provider/offices/full_provider_office",
      as: :provider_office
    )
  end
end
