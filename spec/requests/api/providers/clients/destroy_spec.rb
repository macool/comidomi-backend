require "rails_helper"

RSpec.describe Api::Provider::ClientsController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    let(:client) {
      create :provider_client,
             provider_profile: provider.provider_profile
    }

    describe "performs a soft delete" do
      before do
        client # make sure item is there
        post_with_headers(
          "/api/provider/clients/#{client.id}",
          "_method" => "DELETE"
        )
      end

      it {
        expect(client.reload.deleted_at).to be_present
      }
    end

    describe "already deleted client" do
      before { client.soft_destroy }

      it "raises exception" do
        expect {
          post_with_headers(
            "/api/provider/clients/#{client.id}",
            "_method" => "DELETE"
          )
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "can't destroy another provider's client" do
      let(:client) { create :provider_client }

      before { client }

      it {
        expect {
          post_with_headers(
            "/api/provider/clients/#{client.id}",
            "_method" => "DELETE"
          )
        }.to raise_error(ActiveRecord::RecordNotFound)

        expect(client.reload.deleted_at).to_not be_present
      }
    end
  end
end
