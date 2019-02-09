# == Schema Information
#
# Table name: user_devices
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  platform   :string           not null
#  uuid       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :user_device do
    user
    uuid     { Faker::Internet.device_token }
    platform { UserDevice.platform.values.sample }
  end
end
