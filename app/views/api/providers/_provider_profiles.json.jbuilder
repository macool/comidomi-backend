##
# provider_profile's public template

json.partial!(
  "provider_profile",
  provider_profile: provider_profile
)

# only enabled offices
json.provider_offices do
  json.array!(
    provider_profile.offices.enabled.decorate,
    partial: "api/providers/offices/provider_office",
    as: :provider_office
  )
end
