# == Schema Information
#
# Table name: user_locations
#
#  id         :integer          not null, primary key
#  lat        :string           not null
#  lon        :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#

FactoryGirl.define do
  factory :user_location do
    lat "-3.792134532423"
    lon "72.43214254556"
    user
  end
end
