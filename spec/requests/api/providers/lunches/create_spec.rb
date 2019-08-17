require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "create as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }
    let(:attributes) {
      attributes_for(:provider_lunch).merge(
        lunch_items_attributes: [
          attributes_for(:provider_lunch_item)
        ]
      )
    }

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
        lunch_item = provider_lunch.lunch_items.first
        expect(
          lunch_item.name
        ).to eq(attributes[:lunch_items_attributes].first[:name])
        expect(
          lunch_item.kind
        ).to eq(attributes[:lunch_items_attributes].first[:kind])
      end

      it "response serialization" do
        json = JSON.parse(response.body)
        expect(json).to have_key("provider_lunch")
        expect(json["provider_lunch"]).to have_key("precio_cents")
        expect(
          json["provider_lunch"]["lunch_items"].first
        ).to have_key("name")
      end
    end
  end
end
