# == Schema Information
#
# Table name: shipping_requests
#
#  id                  :integer          not null, primary key
#  resource_id         :integer          not null
#  resource_type       :string           not null
#  kind                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  status              :string           default("new"), not null
#  address_attributes  :json
#  courier_profile_id  :integer
#  reason              :string
#  place_id            :integer          not null
#  waypoints           :json
#  estimated_time_mins :integer
#  assigned_at         :datetime
#  ref_lat             :float            not null
#  ref_lon             :float            not null
#

require 'rails_helper'

RSpec.describe ShippingRequest,
               type: :model do
  describe "factory" do
    let(:provider_profile) { create :provider_profile }
    subject {
      build :shipping_request,
            :with_address_attributes,
            resource: provider_profile
    }
    it { is_expected.to be_valid }
    it {
      subject.save
      expect(
        subject.reload.resource_id
      ).to eq(provider_profile.id)
      expect(
        subject.reload.resource_type
      ).to eq(provider_profile.class.to_s)
    }
  end

  describe "serializes address attributes" do
    subject { build :shipping_request }
    let(:attributes) { { some: :address, lat: "0", lon: "0" } }
    before { subject.update! address_attributes: attributes }
    it {
      expect(
        subject.reload.address_attributes["some"]
      ).to eq("address")
    }
  end
end
