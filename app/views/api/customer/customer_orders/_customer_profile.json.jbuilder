json.extract!(
  customer_profile.user.decorate, # from user
  :image_url,
  :name,
  :ciudad,
  :phone_number
)

# we're only using a part of this
# json.name customer_profile.user.name.presence
# json.nickname customer_profile.user.nickname.presence
