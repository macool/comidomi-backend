require "rails_helper"

RSpec.describe Api::Customer::WishlistsController,
               type: :request do
  include TimeZoneHelpers

  let(:user) { create :user }
  before { login_as user }

  describe "creates a wishlist" do
    let(:provider_category) {
      create :provider_category
    }
    let(:provider_profile) {
      create :provider_profile, provider_category: provider_category
    }
    let(:provider_item) {
      create :provider_item, provider_profile: provider_profile
    }
    let(:attributes) {
      attributes_for :customer_wishlist,
                     :deliver_later,
                     provider_items_ids: [provider_item.id]
    }

    let(:resp_customer_wishlist) {
      JSON.parse(response.body).fetch("customer_wishlist")
    }

    before do
      provider_item

      expect {
        post_with_headers(
          "/api/customer/wishlists",
          attributes
        )
      }.to change { CustomerWishlist.count }.by(1)
    end

    it "customer_profile gets automatically created" do
      customer_profile = user.reload.customer_profile
      expect(customer_profile).to be_persisted
    end

    it "customer_wishlist belongs to right customer_profile" do
      customer_wishlist = CustomerWishlist.last

      expect(
        customer_wishlist.customer_profile
      ).to eq(user.reload.customer_profile)
    end

    it "persists attributes" do
      expect(
        resp_customer_wishlist["nombre"]
      ).to eq(attributes[:nombre])

      expect(
        resp_customer_wishlist["entregar_en"]
      ).to eq(
        formatted_time(attributes[:entregar_en])
      )

      resp_provider_item = resp_customer_wishlist["provider_items"].detect do |item|
        item["id"] == provider_item.id
      end

      expect(
        resp_provider_item["provider_profile_id"]
      ).to eq(provider_item.provider_profile.id)

      resp_provider_profile = JSON.parse(response.body).fetch("provider_profiles").detect do |profile|
        profile["id"] == provider_item.provider_profile.id
      end

      expect(
        resp_provider_profile["provider_category_id"]
      ).to eq(provider_category.id)
    end
  end
end
