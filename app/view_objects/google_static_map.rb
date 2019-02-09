require "uri"

class GoogleStaticMap
  MAPS_URI = "https://maps.googleapis.com/maps/api/staticmap".freeze

  def initialize(options)
    defaults = {
      zoom: 16,
      size: "200x200",
      maptype: "roadmap",
      language: Rails.application.config.i18n.default_locale,
      key: Rails.application.secrets.google_maps_key
    }
    @options = defaults.merge(options)
    if @options[:center].blank? && @options[:markers].blank?
      raise ArgumentError
    end
  end

  def to_s
    MAPS_URI + "?" + parameters
  end

  def parameters
    URI.encode_www_form @options
  end
end
