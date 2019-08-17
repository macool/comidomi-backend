# == Schema Information
#
# Table name: provider_lunches
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  precio_cents        :integer          default(0), not null
#  precio_currency     :string           default("USD"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :provider_lunch do
    provider_profile

    precio { Faker::Commerce.price }
  end
end
