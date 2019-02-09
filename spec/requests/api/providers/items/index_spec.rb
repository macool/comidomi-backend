require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "as non-provider" do
    let(:user) { create :user }
    before {
      login_as user
      get_with_headers "/api/provider/items"
    }
    it "says I'm not authorised" do
      expect(response.status).to eq(401)
    end
  end

  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "lists my items" do
      let!(:provider_item) {
        create :provider_item,
               provider_profile: provider.provider_profile
      }
      let!(:other_provider_item) {
        create :provider_item
      }

      before {
        get_with_headers "/api/provider/items"
      }

      let(:json) {
        JSON.parse response.body
      }

      it "response includes my item" do
        my_item = json["provider_items"].detect do |item|
          item["id"] == provider_item.id
        end
        expect(my_item).to be_present
      end

      it "response doesn't include other's item" do
        others_item = json["provider_items"].detect do |item|
          item["id"] == other_provider_item.id
        end
        expect(others_item).to_not be_present
      end
    end
  end
end
