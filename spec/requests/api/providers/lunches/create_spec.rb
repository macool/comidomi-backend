require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "create as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }
    let(:attributes) { attributes_for :provider_lunch }

    describe "with invalid attributes" do
      let(:invalid_attributes) {
        attributes_for(:provider_lunch).except(:precio)
      }
      before {
        post_with_headers(
          "/api/provider/lunches",
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
            "/api/provider/lunches",
            attributes
          )
        }.to change { ProviderLunch.count }.by(1)
      end

      it "creates a provider_item and assigns attributes" do
        provider_lunch = ProviderLunch.last
        expect(
          provider_lunch.provider_profile
        ).to eq(provider.provider_profile)
        expect(
          provider_lunch.precio.to_f
        ).to eq(attributes[:precio])
      end

      it "response serialization" do
        json = JSON.parse(response.body)
        expect(json).to have_key("provider_lunch")
        expect(json["provider_lunch"]).to have_key("precio_cents")
      end
    end
  end
end
