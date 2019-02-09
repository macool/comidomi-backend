# == Schema Information
#
# Table name: places
#
#  id                  :integer          not null, primary key
#  lat                 :string
#  lon                 :string
#  nombre              :string           not null
#  country             :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  price_per_km_cents  :integer          default(1)
#  factor_per_distance :float            default(0.1)
#  enabled             :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :place do
    sequence(:nombre) { |n| "ciudad #{n}" }
    lat     { Faker::Address.latitude }
    lon     { Faker::Address.longitude }
    country "Ecuador"

    trait :enabled do
      enabled true
    end
  end
end
