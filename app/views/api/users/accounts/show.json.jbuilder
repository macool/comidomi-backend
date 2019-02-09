json.user do
  json.partial!(
    "api/users/accounts/user",
    user: @api_resource
  )
end
