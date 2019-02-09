json.extract!(
  place,
  :id,
  :lat,
  :lon,
  :nombre,
  :country,
  :flag_image_url,
  :currency_iso_code
)

json.full_str place.to_s
