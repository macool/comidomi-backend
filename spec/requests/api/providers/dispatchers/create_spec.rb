require "rails_helper"

RSpec.describe Api::Provider::DispatchersController,
               type: :request do
  describe "non-provider can't use endpoint" do
    let(:user) { create :user }
    before {
      login_as user
      post_with_headers(
        "/api/provider/dispatchers",
        attributes_for(:provider_dispatcher)
      )
    }
    it {
      expect(response.status).to eq(401)
    }
  end

  describe "as provider" do
    let(:place) { create :place, nombre: "loh" }
    let(:provider) {
      create :user, :provider, current_place: place
    }
    let(:provider_office) {
      create :provider_office,
             provider_profile: provider.provider_profile
    }
    let(:attributes) {
      attributes_for(:provider_dispatcher).merge(
        provider_office_id: provider_office.id
      )
    }
    before {
      provider_office
      login_as provider
    }

    describe "with invalid attributes" do
      let(:invalid_attributes) {
        attributes.except(:email)
      }
      before {
        post_with_headers(
          "/api/provider/dispatchers",
          invalid_attributes
        )
      }

      it "response includes errors" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to have_key("email")
      end
    end

    describe "with valid attributes" do
      before do
        expect {
          post_with_headers(
            "/api/provider/dispatchers",
            attributes
          )
        }.to change { ProviderDispatcher.count }.by(1)
      end

      it {
        json_response = JSON.parse(response.body)["provider_dispatcher"]

        expect(
          json_response["email"]
        ).to eq(attributes[:email])

        expect(
          json_response["provider_office_id"]
        ).to eq(provider_office.id)
      }
    end

    describe "can't assign to another provider's office" do
      let(:other_office) {
        create :provider_office
      }

      let(:invalid_attributes) {
        attributes_for(:provider_dispatcher).merge(
          provider_office_id: other_office.id
        )
      }

      before {
        other_office
        post_with_headers(
          "/api/provider/dispatchers",
          invalid_attributes
        )
      }

      it "unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
