# == Schema Information
#
# Table name: provider_item_promo_weekdays
#
#  id                     :integer          not null, primary key
#  provider_item_promo_id :integer          not null
#  wkday                  :string           not null
#  available              :boolean          default(FALSE)
#

class ProviderItemPromoWeekday < ActiveRecord::Base
  belongs_to :provider_item_promo

  scope :available, ->{ where(available: true) }
end
