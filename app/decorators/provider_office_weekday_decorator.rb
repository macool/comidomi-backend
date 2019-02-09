class ProviderOfficeWeekdayDecorator < GenericResourceDecorator
  def to_s
    "#{day_text} (#{abierto_str})"
  end

  def abierto_str
    if abierto?
      state = "abierto"
    else
      state = "cerrado"
    end
    h.t("activerecord.attributes.provider_office_weekday.#{state}")
  end
end
