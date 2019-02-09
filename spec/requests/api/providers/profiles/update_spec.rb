require "rails_helper"

RSpec.describe Api::Provider::ProfilesController,
               type: :request do
  let(:user) { create :user, :provider }
  before { login_as user }

  describe "as a provider" do
    let(:attributes) { attributes_for(:provider_profile) }

    before do
      expect {
        put_with_headers "/api/provider/profile", attributes
      }.to_not change(ProviderProfile, :count)
    end

    it "I update my profile" do
      response_profile = JSON.parse(response.body).fetch("provider_profile")
      expect(
        response_profile["nombre_establecimiento"]
      ).to eq(attributes[:nombre_establecimiento])
    end
  end

  describe "logs event" do
    it "on update", versioning: true do
      put_with_headers(
        "/api/provider/profile",
        attributes_for(:provider_profile)
      )

      version = PaperTrail::Version.last
      expect(version.event).to eq("update")
      expect(version.item).to eq(user.provider_profile)
    end
  end
end
