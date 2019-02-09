json.extract!(
  provider_office,
  :id,
  :direccion,
  :place_id,
  :telefono,
  :lat,
  :lon,
  :static_map_image
)

json.weekdays do
  json.array!(
    provider_office.weekdays.object.sorted,
    partial: "api/providers/offices/weekday",
    as: :provider_office_weekday
  )
end
