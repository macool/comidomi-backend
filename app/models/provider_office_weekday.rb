# == Schema Information
#
# Table name: provider_office_weekdays
#
#  id                 :integer          not null, primary key
#  provider_office_id :integer          not null
#  day                :string           not null
#  abierto            :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  hora_de_apertura   :datetime
#  hora_de_cierre     :datetime
#

class ProviderOfficeWeekday < ActiveRecord::Base
  extend Enumerize

  DAY_NAMES = Date::ABBR_DAYNAMES.map(&:downcase)

  has_paper_trail

  enumerize :day,
            in: DAY_NAMES,
            i18n_scope: "enumerize.defaults.daynames"

  begin :relationships
    belongs_to :provider_office
  end

  def self.sorted
    all.sort_by do |wday|
      DAY_NAMES.index(wday.day)
    end
  end

  [
    :hora_de_cierre,
    :hora_de_apertura
  ].each do |attribute_name|
    define_method "#{attribute_name}=" do |new_time|
      ##
      # support setting schedule with custom format:
      schedule_format = I18n.t("time.formats.office_schedule")
      if new_time.present? && new_time.length < 6
        # assume it's system's TZ
        new_time += Time.zone.formatted_offset
      end
      begin
        new_time = DateTime.strptime(new_time, schedule_format)
      rescue ArgumentError
        # fallback to write as is
      end
      old_time = send(attribute_name)
      if old_time.present? && new_time.present?
        old_time_str = old_time.in_time_zone.strftime(schedule_format)
        new_time_str = new_time.in_time_zone.strftime(schedule_format)
        return if old_time_str == new_time_str
      end
      send :write_attribute, attribute_name, new_time
    end
  end
end
