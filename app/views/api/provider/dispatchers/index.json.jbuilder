json.provider_dispatchers do
  json.array!(
    @api_collection,
    partial: "dispatcher",
    as: :provider_dispatcher
  )
end
