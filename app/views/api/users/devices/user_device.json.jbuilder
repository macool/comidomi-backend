json.user_device do
  json.extract!(
    @api_resource.user_device,
    :id,
    :platform
  )
end
