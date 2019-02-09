# == Schema Information
#
# Table name: site_preferences
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :site_preference do
    sequence(:name) { |n| "preference-#{n}" }
    content         { "mypref" }
  end
end
