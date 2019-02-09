json.extract!(
  provider_office_weekday,
  :id,
  :day,
  :abierto
)

json.hora_de_apertura(
  l(provider_office_weekday.hora_de_apertura, format: :office_schedule)
) if provider_office_weekday.hora_de_apertura.present?
json.hora_de_cierre(
  l(provider_office_weekday.hora_de_cierre, format: :office_schedule)
) if provider_office_weekday.hora_de_cierre.present?
