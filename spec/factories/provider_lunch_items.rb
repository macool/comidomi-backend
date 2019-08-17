# == Schema Information
#
# Table name: provider_lunch_items
#
#  id                :integer          not null, primary key
#  provider_lunch_id :integer          not null
#  kind              :string           not null
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :provider_lunch_item do
    provider_lunch
    kind ProviderLunchItem::KINDS.sample
    name { Faker::Commerce.product_name }
  end
end
