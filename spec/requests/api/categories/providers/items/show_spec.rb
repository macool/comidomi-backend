require "rails_helper"

RSpec.describe Api::ItemsController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "show a provider's public item" do
    let(:category) { create :provider_category }
    let(:provider_profile){
      create :provider_profile,
             provider_category: category
    }
    let(:provider_item) {
      create :provider_item,
             :en_stock,
             :available,
             provider_profile: provider_profile
    }

    before do
      category
      provider_profile
      provider_item
      get_with_headers(
        "/api/categories/#{category.id}/providers/#{provider_profile.id}/items/#{provider_item.id}"
      )
    end

    it "should respond with provider item" do
      resp_provider_item = JSON.parse(response.body).fetch("provider_item")
      expect(resp_provider_item["titulo"]).to eq(provider_item.titulo)
    end
  end
end
