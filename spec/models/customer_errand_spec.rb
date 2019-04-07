# == Schema Information
#
# Table name: customer_errands
#
#  id                           :integer          not null, primary key
#  customer_profile_id          :integer          not null
#  place_id                     :integer          not null
#  description                  :text             not null
#  customer_address_id          :integer          not null
#  shipping_fare_price_cents    :integer          default(0), not null
#  shipping_fare_price_currency :string           default("USD"), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  status                       :string           default("in_progress"), not null
#

require 'rails_helper'

RSpec.describe CustomerErrand, type: :model do
  it {
    errand = build(:customer_errand)
    expect(errand).to be_valid
  }

  describe "updates status when shipping request is finished" do
    it {
      errand = create :customer_errand
      shipping_request = create(
        :shipping_request,
        kind: :customer_errand,
        resource: errand,
        ref_lat: 1,
        ref_lon: 1
      )
      expect(errand.status).to be_in_progress
      shipping_request.update!(status: :delivered)
      errand.reload
      expect(errand.status).to be_delivered
    }

    it {
      errand = create :customer_errand
      shipping_request = create(
        :shipping_request,
        kind: :customer_errand,
        resource: errand,
        ref_lat: 1,
        ref_lon: 1
      )
      expect(errand.status).to be_in_progress
      shipping_request.update!(status: :canceled)
      errand.reload
      expect(errand.status).to be_canceled
    }
  end
end
