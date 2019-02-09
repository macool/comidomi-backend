require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "non-provider can't use endpoint" do
    let(:user) { create :user }
    before {
      login_as user
      post_with_headers(
        "/api/provider/items",
        attributes_for(:provider_item)
      )
    }
    it {
      expect(response.status).to eq(401)
    }
  end

  describe "create as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }
    let(:attributes) { attributes_for :provider_item }

    describe "with invalid attributes" do
      let(:invalid_attributes) {
        # without a required attribute
        attributes_for(:provider_item).except(:precio)
      }
      before {
        post_with_headers(
          "/api/provider/items",
          invalid_attributes
        )
      }

      it "response includes errors" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to have_key("precio")
      end
    end

    describe "with valid attributes" do
      before do
        expect {
          post_with_headers(
            "/api/provider/items",
            attributes
          )
        }.to change { ProviderItem.count }.by(1)
      end

      it "creates a provider_item and assigns attributes" do
        provider_item = ProviderItem.last
        expect(
          provider_item.provider_profile
        ).to eq(provider.provider_profile)
        expect(
          provider_item.titulo
        ).to eq(attributes[:titulo])
      end

      it "response serialization" do
        json = JSON.parse(response.body)
        expect(json).to have_key("provider_item")
        expect(
          json["provider_item"]
        ).to have_key("created_at")
      end
    end
  end
end
