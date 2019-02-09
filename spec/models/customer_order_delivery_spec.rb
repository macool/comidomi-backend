# == Schema Information
#
# Table name: customer_order_deliveries
#
#  id                          :integer          not null, primary key
#  deliver_at                  :datetime
#  delivery_method             :string           not null
#  customer_address_id         :integer
#  customer_address_attributes :json
#  provider_profile_id         :integer
#  customer_order_id           :integer          not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  status                      :string           default("draft"), not null
#  reason                      :text
#  shipping_fare_price_cents   :integer
#  preparation_time_mins       :integer
#  provider_responded_at       :datetime
#  dispatch_at                 :datetime
#

require 'rails_helper'

RSpec.describe CustomerOrderDelivery,
               type: :model do
  describe "factory" do
    subject { build :customer_order_delivery }
    it { is_expected.to be_valid }
  end

  describe "validates own address" do
    subject { build :customer_order_delivery }
    let(:customer_address) { create :customer_address }
    before {
      subject.customer_address = customer_address
    }
    it {
      is_expected.to_not be_valid
      expect(subject.errors).to have_key(:customer_address_id)
    }
  end

  describe "deliver_at must be in future" do
    subject { build :customer_order_delivery }
    it {
      subject.deliver_at = 1.week.ago
      is_expected.to_not be_valid
      expect(
        subject.errors
      ).to have_key(:deliver_at)
    }
    it {
      subject.deliver_at = 1.week.from_now
      is_expected.to be_valid
    }
  end
end
