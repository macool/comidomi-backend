json.customer_wishlist do
  json.partial!(
    "customer_wishlist",
    customer_wishlist: @api_resource
  )
end

json.provider_profiles do
  json.array!(
    @provider_profiles,
    partial: "provider_profile",
    as: :provider_profile
  )
end
