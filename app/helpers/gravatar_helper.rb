require "digest/md5"

module GravatarHelper
  def gravatar_image_url(email, default = "identicon")
    hash = Digest::MD5.hexdigest(email) if email.present?
    size = 250
    schema = Rails.application.config.force_ssl ? "https:" : "http:"
    "#{schema}//www.gravatar.com/avatar/#{hash}?s=#{size}&d=#{default}"
  end
end
