# == Schema Information
#
# Table name: provider_dispatchers
#
#  id                 :integer          not null, primary key
#  provider_office_id :integer          not null
#  email              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#

FactoryGirl.define do
  factory :provider_dispatcher do
    provider_office

    email { Faker::Internet.email }
  end
end
