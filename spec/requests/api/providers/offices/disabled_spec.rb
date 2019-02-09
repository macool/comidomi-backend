require "rails_helper"

RSpec.describe Api::Provider::OfficesController,
               type: :request do
  describe "as a disabled provider" do
    let(:user) { create :user }
    let(:provider_profile) {
      create :provider_profile,
             :with_provider_category,
             user: user,
             status: :disabled
    }

    before do
      provider_profile
      login_as user
    end

    it "response" do
      response_user = JSON.parse(response.body)["data"]
      expect(
        response_user["provider_profile"]["status"]
      ).to eq("disabled")
    end

    it "can't perform write operations" do
      attributes = attributes_for(:provider_office)
      expect {
        post_with_headers "/api/provider/offices", attributes
      }.to_not change(ProviderOffice, :count)
    end
  end
end
