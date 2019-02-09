module TimeZoneHelpers
  def formatted_time(time)
    I18n.l(
      time.in_time_zone(
        Rails.application.config.time_zone
      ),
      format: :api
    )
  end
end
