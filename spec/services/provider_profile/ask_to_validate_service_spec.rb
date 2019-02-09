require "rails_helper"

describe ProviderProfile::TransitionTo::AskToValidateService,
         type: :model do
  subject {
    described_class.new(provider_profile)
  }

  describe "valid" do
    let(:provider_profile) {
      create :provider_profile, :with_provider_category, :with_office
    }
    it { is_expected.to be_valid }

    describe "persist office address" do
      before { expect(subject.perform).to be_truthy }
      it {
        expect(
          ShippingRequest.last.address_attributes["place_id"]
        ).to eq(provider_profile.offices.first.place_id)
      }
    end
  end

  describe "invalid without office address" do
    let(:provider_profile) { create :provider_profile }
    before { expect(provider_profile.offices.count).to eq(0) }
    it {
      is_expected.to_not be_valid
      expect(subject.perform).to be_falsey
    }
  end
end
