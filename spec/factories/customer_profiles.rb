# == Schema Information
#
# Table name: customer_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :customer_profile do
    user
  end
end
