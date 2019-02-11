class UserDecorator < GenericResourceDecorator
  decorates_association :provider_profile
  decorates_association :courier_profile

  def provider_profile_with_link
    provider_profile.str_with_link if provider_profile.present?
  end

  def courier_profile_with_link
    courier_profile.str_with_link if courier_profile.present?
  end

  def to_s
    object.name.presence || object.nickname.presence || object.email
  end

  def image_url
    custom_image_url.presence || image.presence || gravatar_image || gravatar_mystery_man
  end

  def card_attributes
    [
      :provider,
      :uid,
    ]
  end

  def detail_attributes
    card_attributes + [
      :email,
      :nickname,
      :ciudad,
      :fecha_nacimiento,
      :provider_profile_with_link,
      :devices_count
    ]
  end

  def highest_privilege
    privileges.sort_by do |privilege|
      User::PRIVILEGES.index(privilege)
    end.last
  end

  def custom_image_url
    custom_image.small_cropped.url if custom_image?
  end

  ##
  # i.e. from 3rd party
  def image
    case provider
    when "facebook"
      # force a square
      width = 500
      height = 500
      "https://graph.facebook.com/#{object.uid}/picture?width=#{width}&height=#{height}"
    else
      object.image
    end
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to(
      h.admin_user_path(object),
      options,
      &block
    )
  end

  def devices_count
    user_devices.count
  end

  private

  def gravatar_image
    h.gravatar_image_url(email) if email.present?
  end

  def gravatar_mystery_man
    h.gravatar_image_url(nil, "mm")
  end
end
