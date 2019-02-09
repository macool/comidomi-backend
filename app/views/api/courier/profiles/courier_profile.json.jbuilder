json.courier_profile do
  json.partial!(
    "api/couriers/courier_profile",
    courier_profile: @api_resource
  )
end
