require "rails_helper"

RSpec.describe Api::Provider::ClientsController,
               type: :request do
  describe "non-provider can't use endpoint" do
    let(:user) { create :user }
    before {
      login_as user
      post_with_headers(
        "/api/provider/clients",
        attributes_for(:provider_client)
      )
    }
    it {
      expect(response.status).to eq(401)
    }
  end

  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }
    let(:attributes) { attributes_for :provider_client }

    describe "with invalid attributes" do
      let(:invalid_attributes) {
        attributes_for(:provider_client).except(:ruc)
      }
      before {
        post_with_headers(
          "/api/provider/clients",
          invalid_attributes
        )
      }

      it "response includes errors" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to have_key("ruc")
      end
    end

    describe "with valid attributes" do
      before do
        expect {
          post_with_headers(
            "/api/provider/clients",
            attributes
          )
        }.to change { ProviderClient.count }.by(1)
      end

      it {
        provider_client = ProviderClient.last
        expect(
          provider_client.provider_profile
        ).to eq(provider.provider_profile)
        expect(
          provider_client.ruc
        ).to eq(attributes[:ruc])
      }
    end
  end
end
