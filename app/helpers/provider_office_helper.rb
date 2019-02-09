module ProviderOfficeHelper
  def office_schedule(time)
    if time.present?
      l(time.in_time_zone, format: :hour_only)
    end
  end
end
