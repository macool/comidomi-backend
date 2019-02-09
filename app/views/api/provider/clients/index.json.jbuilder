json.provider_clients do
  json.array!(
    @api_collection,
    partial: "client",
    as: :provider_client
  )
end
