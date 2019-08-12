# == Schema Information
#
# Table name: provider_item_promo_weekdays
#
#  id                     :integer          not null, primary key
#  provider_item_promo_id :integer          not null
#  wkday                  :string           not null
#  available              :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :provider_item_promo_weekday do
    provider_item_promo {
      build(:provider_item, :promo).becomes(ProviderItemPromo)
    }
    wkday "MyString"
    available false
  end
end
