class PlaceDecorator < GenericResourceDecorator
  def static_map_image(options = {})
    defaults = { alt: nombre }
    static_map = GoogleStaticMap.new(
      zoom: 12,
      center: "#{lat},#{lon}"
    )
    h.image_tag static_map, defaults.merge(options)
  end

  def flag_image_tag(options = {})
    defaults = {
      alt: country_code.upcase,
      width: 64
    }
    h.image_tag flag_image_url, defaults.merge(options)
  end

  def flag_image_url
    h.image_url("country-4x3/#{country_code}.svg")
  end

  def country_code
    @country_code ||= ISO3166::Country.find_country_by_name(
      country
    ).alpha2.downcase
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to h.admin_places_path, options, &block
  end

  def shipping_fares
    object.shipping_fares.smaller.decorate
  end
end
