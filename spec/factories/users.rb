# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  info                   :json
#  credentials            :json
#  tokens                 :json
#  created_at             :datetime
#  updated_at             :datetime
#  fecha_nacimiento       :date
#  ciudad                 :string
#  privileges             :text             default([]), is an Array
#  custom_image           :string
#  agreed_tos             :boolean          default(FALSE)
#  current_place_id       :integer
#  phone_number           :string
#

FactoryGirl.define do
  factory :user do
    name                  { Faker::Name.name }
    nickname              { Faker::Internet.user_name }
    image                 { Faker::Avatar.image }
    email                 { Faker::Internet.email }
    password              { Faker::Internet.password }
    password_confirmation { password }

    after(:build) do |user|
      if user.current_place.blank?
        if Place.first.present?
          user.current_place = Place.first
        else
          user.current_place = build(:place)
        end
      end
    end

    ##
    # defines traits with privileges
    User::PRIVILEGES.each do |privilege|
      trait privilege do
        after :create do |user|
          user.privileges << privilege
          user.save!
        end
      end
    end

    trait :with_personal_info do
      ciudad              { Faker::Address.city }
      fecha_nacimiento    { Faker::Date.birthday }
    end

    trait :provider do
      after :create do |user|
        create :provider_profile, user: user
      end
    end

    trait :courier do
      after :create do |user|
        create :courier_profile, user: user
      end
    end

    trait :customer do
      after :create do |user|
        create :customer_profile, user: user
      end
    end
  end
end
