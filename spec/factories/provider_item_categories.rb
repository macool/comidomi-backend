# == Schema Information
#
# Table name: provider_item_categories
#
#  id                  :integer          not null, primary key
#  nombre              :string
#  predeterminada      :boolean          default(FALSE)
#  provider_profile_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :provider_item_category do
    nombre  { Faker::Commerce.department }

    trait :personal do
      provider_profile
    end

    trait :default do
      predeterminada true
    end
  end
end
