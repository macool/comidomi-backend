require "rails_helper"

RSpec.describe Api::ProvidersController,
               type: :request do
  let(:place) { create :place, nombre: "loh" }
  let(:user) { create :user, current_place: place }
  before { login_as user }

  describe "show a provider's public profile including their items for offer" do
    let(:category) { create :provider_category }
    let(:other_provider_item) { create :provider_item }
    let(:provider_profile){
      create :provider_profile,
             status: :active,
             provider_category: category
    }
    let(:provider_item) {
      create :provider_item,
             :with_imagen,
             :en_stock,
             :available,
             provider_profile: provider_profile,
             precio_currency: provider_office.place.currency_iso_code
    }
    let(:provider_office) {
      create :provider_office,
             :enabled,
             provider_profile: provider_profile
    }
    let(:default_provider_item_category) {
      create :provider_item_category, :default
    }

    before do
      default_provider_item_category
      provider_profile
      provider_item
      other_provider_item
      provider_office
      get_with_headers "/api/categories/#{category.id}/providers/#{provider_profile.id}"
    end

    let(:json) {
      JSON.parse response.body
    }

    let(:provider_from_response) {
      providers = json["provider_profile"]
    }

    let(:provider_items_from_response) {
      provider_from_response.fetch(
        "provider_item_categories"
      ).first.fetch("provider_items")
    }

    it "should include provider products" do
      item_from_response = provider_items_from_response.detect do |i|
        i["id"] == provider_item.id
      end
      expect(item_from_response).to be_present
    end

    it "response doesn't include other's products" do
      other_item = provider_items_from_response.detect do |item|
        item["id"] == other_provider_item.id
      end
      expect(other_item).to_not be_present
    end

    it "includes full provider profile" do
      provider_office = provider_from_response["provider_offices"].first
      expect(
        provider_office["weekdays"].first
      ).to have_key("hora_de_apertura")
    end

    it "doesn't include provider profile private attributes" do
      expect(
        provider_from_response
      ).to_not have_key("banco_identificacion")
    end

    it "doesn't include provider office private attributes" do
      expect(
        provider_from_response["provider_offices"].first
      ).to_not have_key("enabled")
    end

    it "doesn't include provider item private attributes" do
      expect(
        provider_items_from_response.first
      ).to_not have_key("created_at")
    end
  end
end
