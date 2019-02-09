# == Schema Information
#
# Table name: shipping_fares
#
#  id             :integer          not null, primary key
#  place_id       :integer          not null
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe ShippingFare,
               type: :model do
  describe "factory" do
    subject { build_stubbed :shipping_fare }
    it { is_expected.to be_valid }
  end
end
