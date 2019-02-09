require "rails_helper"

RSpec.describe Api::Provider::ClientsController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "update my client" do
      let(:client) {
        create :provider_client,
               provider_profile: provider.provider_profile
      }

      let(:new_attrs) { attributes_for(:provider_client) }

      before {
        put_with_headers(
          "/api/provider/clients/#{client.id}",
          new_attrs
        )
      }

      it {
        json = JSON.parse response.body
        expect(
          json["provider_client"]["nombres"]
        ).to eq(new_attrs[:nombres])
      }
    end

    describe "can't update other provider's client" do
      let(:client) { create :provider_client }

      it "is out of my scope" do
        expect {
          put_with_headers "/api/provider/clients/#{client.id}"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
