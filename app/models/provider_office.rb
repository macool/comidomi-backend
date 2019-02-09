# == Schema Information
#
# Table name: provider_offices
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  enabled             :boolean          default(FALSE)
#  direccion           :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  telefono            :string
#  place_id            :integer
#  lat                 :float            not null
#  lon                 :float            not null
#

class ProviderOffice < ActiveRecord::Base
  extend Enumerize

  has_paper_trail
  acts_as_mappable(
    lng_column_name: :lon
  )

  begin :relationships
    belongs_to :provider_profile
    belongs_to :place
    has_many :provider_dispatchers,
             dependent: :destroy
    has_many :weekdays,
             class_name: "ProviderOfficeWeekday",
             dependent: :destroy
  end

  begin :validations
    validates :direccion,
              :lat,
              :lon,
              presence: true
    validates :place_id, presence: true
    validate :validate_right_weekdays
  end

  scope :enabled, -> { where(enabled: true) }
  scope :for_place, ->(place) { where(place: place) }

  accepts_nested_attributes_for(
    :weekdays
  )

  ##
  # builds default weekdays
  def build_weekdays
    ProviderOfficeWeekday::DAY_NAMES.map do |wday|
      weekdays.build(day: wday)
    end
  end

  private

  def validate_right_weekdays
    right_length = weekdays.length == ProviderOfficeWeekday::DAY_NAMES.length
    if !right_length || !all_weekdays_included?
      errors.add(:base, :wrong_weekdays)
    end
  end

  def all_weekdays_included?
    ProviderOfficeWeekday::DAY_NAMES.all? do |dayname|
      weekdays.any? do |weekday|
        weekday.day == dayname
      end
    end
  end
end
