require "rails_helper"

RSpec.describe Api::Customer::WishlistsController,
               type: :request do
  include TimeZoneHelpers

  before { login_as user }

  let(:response_wishlists) {
    JSON.parse(response.body).fetch("customer_wishlists")
  }

  describe "non-customer" do
    let(:user) { create :user }

    before do
      expect {
        get_with_headers "/api/customer/wishlists"
      }.to_not change(CustomerWishlist, :count)
    end

    it "doesn't create any customer profile" do
      expect(
        user.customer_profile
      ).to_not be_present
    end

    it "response is empty" do
      expect(
        response_wishlists
      ).to be_empty
    end
  end

  describe "customer" do
    let(:user) { create :user, :customer }

    let(:other_wishlist) { create :customer_wishlist }
    let(:my_wishlist) {
      create :customer_wishlist,
             customer_profile: user.customer_profile
    }
    let(:my_wishlist_for_later) {
      create :customer_wishlist,
             :deliver_later,
             customer_profile: user.customer_profile
    }

    before do
      my_wishlist
      other_wishlist
      my_wishlist_for_later

      get_with_headers "/api/customer/wishlists"
    end

    it "includes my wishlist" do
      my_response_wishlist = response_wishlists.detect do |wishlist|
        wishlist["id"] == my_wishlist.id
      end
      expect(my_response_wishlist).to be_present
    end

    it "doesn't include other's wishlists" do
      expect(
        response_wishlists.detect do |wishlist|
          wishlist["id"] == other_wishlist.id
        end
      ).to_not be_present
    end

    it "format for deliver_later" do
      wishlist_in_resp = response_wishlists.detect do |wishlist|
        wishlist["id"] == my_wishlist_for_later.id
      end

      expect(
        wishlist_in_resp["entregar_en"]
      ).to eq(
        formatted_time(my_wishlist_for_later.entregar_en)
      )
    end

    describe "response sideloads providers and items" do
      let(:providers_from_response) {
        JSON.parse(response.body).fetch("provider_profiles")
      }

      let(:provider_category) { create :provider_category }

      let(:provider_profile) {
        create :provider_profile, provider_category: provider_category
      }

      let(:provider_item) {
        create :provider_item, provider_profile: provider_profile
      }

      let(:my_wishlist) {
        create :customer_wishlist,
               provider_items_ids: [provider_item.id],
               customer_profile: user.customer_profile
      }

      it "includes provider_item" do
        response_wishlist = response_wishlists.detect do |wishlist|
          wishlist["id"] == my_wishlist.id
        end

        provider_item_from_response = response_wishlist["provider_items"].first

        expect(
          provider_item_from_response["id"]
        ).to eq(provider_item.id)

        expect(
          provider_item_from_response["provider_profile_id"]
        ).to be_present
      end

      it "sideloads provider profiles" do
        provider_from_response = providers_from_response.first

        expect(
          provider_from_response["id"]
        ).to eq(provider_profile.id)

        expect(
          provider_from_response["provider_category_id"]
        ).to eq(provider_category.id)
      end
    end
  end
end
