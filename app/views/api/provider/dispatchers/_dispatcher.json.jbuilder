json.extract!(
  provider_dispatcher,
  :id,
  :email,
  :provider_office_id
)

if provider_dispatcher.user.present?
  json.user do
    json.partial!(
      "user",
      user: provider_dispatcher.user.decorate
    )
  end
end
