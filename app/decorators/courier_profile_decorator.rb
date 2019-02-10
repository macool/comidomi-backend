class CourierProfileDecorator < GenericResourceDecorator
  def to_s
    nombres
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to h.admin_courier_profile_path(object), options, &block
  end
end
