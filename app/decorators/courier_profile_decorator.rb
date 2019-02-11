class CourierProfileDecorator < GenericResourceDecorator
  def to_s
    nombres
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to h.admin_courier_profile_path(object), options, &block
  end

  def card_attributes
    [
      :ruc,
      :telefono
    ]
  end

  def detail_attributes
    card_attributes + [
      :nombres,
      :email,
      :tipo_medio_movilizacion,
      :fecha_nacimiento,
      :tipo_licencia,
      :place
    ]
  end

  def user_str
    object.user.decorate.to_s
  end
end
