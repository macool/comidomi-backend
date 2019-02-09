json.places do
  json.array!(
    @api_collection,
    partial: "place",
    as: :place
  )
end
