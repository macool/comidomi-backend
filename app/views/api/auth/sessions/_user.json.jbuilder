json.type user.class.name.parameterize

json.partial!(
  "api/users/accounts/user",
  user: user
)

if user.provider_profile.present?
  json.provider_profile do
    json.partial!(
      "api/providers/provider_profile",
      provider_profile: user.provider_profile
    )
    json.partial!(
      "api/providers/private_provider_profile",
      provider_profile: user.provider_profile
    )

    ##
    # all enabled & disabled offices
    json.provider_offices do
      json.array!(
        user.provider_profile.offices.decorate,
        partial: "api/providers/offices/provider_office",
        as: :provider_office
      )
    end
  end
end

if user.courier_profile.present?
  json.courier_profile do
    json.partial!(
      "api/couriers/courier_profile",
      courier_profile: user.courier_profile
    )
  end
end
