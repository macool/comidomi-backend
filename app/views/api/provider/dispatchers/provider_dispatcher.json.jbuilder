json.provider_dispatcher do
  json.partial! 'dispatcher', provider_dispatcher: @api_resource

  json.provider_office do
    json.partial!(
      "api/providers/offices/provider_office",
      provider_office: @api_resource.provider_office.decorate
    )
  end
end
