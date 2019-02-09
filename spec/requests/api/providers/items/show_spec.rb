require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "I can see my items" do
      let(:provider_item) {
        create :provider_item,
               provider_profile: provider.provider_profile
      }

      it {
        provider_item
        get_with_headers "/api/provider/items/#{provider_item.id}"

        json = JSON.parse(response.body)
        expect(
          json.fetch("provider_item").fetch("titulo")
        ).to eq(provider_item.titulo)
      }
    end
  end
end
