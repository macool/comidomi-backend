require "rails_helper"

RSpec.describe Api::Provider,
               type: :request do
  describe "user with provider profile" do
    let(:user) { create :user, :provider }

    let(:response_provider_profile) {
      JSON.parse(response.body)["data"]["provider_profile"]
    }

    it {
      login_as user

      expect(
        response_provider_profile["id"]
      ).to eq(user.provider_profile.id)
    }

    describe "also includes offices" do
      let(:provider_office) {
        create :provider_office,
               provider_profile: user.provider_profile
      }

      before { provider_office }

      it {
        login_as user

        response_office = response_provider_profile["provider_offices"].first
        expect(
          response_office["direccion"]
        ).to eq(provider_office.direccion)
      }
    end
  end
end
