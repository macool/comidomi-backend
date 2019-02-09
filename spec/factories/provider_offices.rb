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

FactoryGirl.define do
  factory :provider_office do
    provider_profile

    lat       "-3.792134532423"
    lon       "72.43214254556"
    direccion { Faker::Address.street_address }
    telefono  { Faker::PhoneNumber.phone_number }
    place {
      if provider_profile.present? && provider_profile.user.present?
        provider_profile.user.current_place
      else
        build :place
      end
    }

    after(:build) do |provider_office|
      ProviderOfficeWeekday::DAY_NAMES.each do |dayname|
        provider_office.weekdays.build(
          attributes_for(:provider_office_weekday).merge(
            day: dayname
          )
        )
      end
    end

    trait :enabled do
      enabled true
    end
  end
end
