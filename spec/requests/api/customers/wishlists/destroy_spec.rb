require "rails_helper"

RSpec.describe Api::Customer::WishlistsController,
               type: :request do
  let(:user) {
    create :user, :customer
  }
  let(:customer_wishlist) {
    create :customer_wishlist,
           customer_profile: user.customer_profile
  }

  before do
    customer_wishlist

    login_as user

    expect {
      post_with_headers(
        "/api/customer/wishlists/#{customer_wishlist.id}",
        "_method" => "DELETE"
      )
    }.to change {
      user.customer_profile.customer_wishlists.count
    }.by(-1)
  end

  it "destroys customer_wishlist" do
    expect(response.status).to eq(204)
  end
end
