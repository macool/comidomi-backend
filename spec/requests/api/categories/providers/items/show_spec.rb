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

  describe "group of provider items" do
    let(:category) { create :provider_category }
    let(:provider_profile) {
      create :provider_profile, provider_category: category
    }
    let(:provider_item_group) {
      create :provider_item,
             :group,
             provider_profile: provider_profile
    }
    let(:nested_provider_item) {
      create :provider_item,
             :en_stock,
             :available,
             provider_profile: provider_profile,
             parent_provider_item_id: provider_item_group.id
    }

    before do
      category
      provider_profile
      provider_item_group
      nested_provider_item
      get_with_headers(
        "/api/categories/#{category.id}/providers/#{provider_profile.id}/items/#{provider_item_group.id}"
      )
    end

    it "should include nested provider item" do
      resp_provider_item = JSON.parse(response.body).fetch("provider_item")
      expect(resp_provider_item["titulo"]).to eq(provider_item_group.titulo)
      expect(resp_provider_item["is_group"]).to be_truthy
      resp_nested_item = resp_provider_item["children"].first
      expect(resp_nested_item["titulo"]).to eq(nested_provider_item.titulo)
    end
  end

  describe "promo" do
    let(:category) { create :provider_category }
    let(:provider_profile) {
      create :provider_profile, provider_category: category
    }
    let(:provider_item_promo) {
      create :provider_item,
             :promo,
             provider_profile: provider_profile
    }
    let(:promo_weekday) {
      create :provider_item_promo_weekday,
             wkday: "sun",
             available: true,
             provider_item_promo: provider_item_promo.becomes(ProviderItemPromo)
    }

    before do
      category
      provider_profile
      provider_item_promo
      promo_weekday
      get_with_headers(
        "/api/categories/#{category.id}/providers/#{provider_profile.id}/items/#{provider_item_promo.id}"
      )
    end

    it "should include promo provider item" do
      resp_provider_item = JSON.parse(response.body).fetch("provider_item")
      expect(resp_provider_item["titulo"]).to eq(provider_item_promo.titulo)
      expect(resp_provider_item["is_promo"]).to be_truthy
      resp_weekday = resp_provider_item["weekdays"].first
      binding.pry
      expect(resp_weekday["available"]).to be_truthy
      expect(resp_weekday["wkday"]).to eq("sun")
    end
  end
end
