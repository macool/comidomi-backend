FactoryGirl.define do
  factory :provider_lunch do
    provider_profile

    precio { Faker::Commerce.price }
  end
end
