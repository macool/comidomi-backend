require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "as non-provider" do
    let(:user) { create :user }
    before { login_as user }
    it {
      get_with_headers "/api/provider/clients"
      expect(response.status).to eq(401)
    }
  end

  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "I see my clients" do
      let(:client) {
        create :provider_client,
               provider_profile: provider.provider_profile
      }
      before {
        client
        get_with_headers "/api/provider/clients"
      }
      it {
        expect(response.body).to include(client.nombres)
      }
    end

    describe "I don't see others' clients" do
      let(:client) { create :provider_client }
      before {
        client
        get_with_headers "/api/provider/clients"
      }
      it {
        expect(response.body).to_not include(client.nombres)
      }
    end
  end
end
