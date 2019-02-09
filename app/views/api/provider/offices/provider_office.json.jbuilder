json.provider_office do
  json.partial!(
    "api/provider/offices/full_provider_office",
    provider_office: @api_resource.decorate
  )
end
