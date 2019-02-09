require "rails_helper"

RSpec.describe Api::Customer::WishlistsController,
               type: :request do
  include TimeZoneHelpers

  let(:user) {
    create :user, :customer
  }
  let(:customer_wishlist) {
    create :customer_wishlist,
           customer_profile: user.customer_profile
  }
  let(:provider_item) {
    create :provider_item
  }

  let(:new_attributes) {
    attributes_for(:customer_wishlist, :deliver_later).slice(
      :nombre,
      :entregar_en
    ).merge(provider_items_ids: [provider_item.id])
  }

  before do
    login_as user

    customer_wishlist

    put_with_headers(
      "/api/customer/wishlists/#{customer_wishlist.id}",
      new_attributes
    )
  end

  let(:response_wishlist) {
    JSON.parse(response.body).fetch("customer_wishlist")
  }

  it "desired attributes are updated" do
    expect(
      response_wishlist["nombre"]
    ).to eq(new_attributes[:nombre])

    expect(
      response_wishlist["entregar_en"]
    ).to eq(
      formatted_time(new_attributes[:entregar_en])
    )

    resp_provider_item = response_wishlist["provider_items"].detect do |item|
      item["id"] == provider_item.id
    end

    expect(
      resp_provider_item["provider_profile_id"]
    ).to eq(provider_item.provider_profile.id)
  end
end
