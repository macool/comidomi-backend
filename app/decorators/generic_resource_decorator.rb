class GenericResourceDecorator < Draper::Decorator
  delegate_all

  def static_map_image(size = :default, markers = nil)
    map_size = {
      default: "600x300",
      xs: "300x150"
    }.fetch(size)
    GoogleStaticMap.new(
      zoom: 16,
      scale: 2,
      size: map_size,
      markers: markers.presence || "#{lat},#{lon}"
    ).to_s
  end

  def link_to_google_map(options = {}, &block)
    latitude = options.fetch(:latitude){ lat }
    longitude = options.fetch(:longitude) { lon }
    uri = "https://maps.google.com?q=#{latitude},#{longitude}"
    defaults = { target: "_blank" }
    h.link_to uri, defaults.merge(options), &block
  end

  def label_for(attribute)
    h.t(
      "activerecord.attributes.#{object_class_name}.#{attribute}"
    ) + ":"
  end

  def hidden_attr_for_history?(key)
    @hidden_attrs ||= [
      :created_at,
      :updated_at
    ].freeze
    @hidden_attrs.include?(key.to_sym)
  end

  def admin_link_to_resource(options=nil, &block)
    h.content_tag :span, options, &block
  end

  def str_with_link
    admin_link_to_resource { to_s }
  end

  private

  def object_class_name
    if object.attributes.has_key?("type")
      object.class.base_class.to_s.underscore
    else
      object.class.to_s.underscore
    end
  end
end
