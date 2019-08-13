# == Schema Information
#
# Table name: provider_item_promo_weekdays
#
#  id                     :integer          not null, primary key
#  provider_item_promo_id :integer          not null
#  wkday                  :string           not null
#  available              :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe ProviderItemPromoWeekday, type: :model do
  describe "factory" do
    it {
      expect(build(:provider_item_promo_weekday)).to be_valid
    }
  end
end
