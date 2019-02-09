require "rails_helper"

RSpec.describe Api::Customer::Cart::ItemsController,
               type: :request do
  let(:user) {
    create :user, :customer
  }
  let(:customer_order) {
    create :customer_order,
           customer_profile: user.customer_profile
  }
  let(:order_item_1) {
    create :customer_order_item,
           :ready_for_checkout,
           customer_order: customer_order
  }
  let(:customer_address) {
    create :customer_address,
           customer_profile: user.customer_profile
  }
  let(:attributes) {
    attributes_for :customer_order_delivery,
                   :shipping,
                   :deliver_later
  }

  before do
    login_as user

    order_item_1
    customer_address

    put_with_headers(
      "/api/customer/cart/deliveries/#{customer_order.deliveries.first.id}",
      attributes.merge(customer_address_id: customer_address.id)
    )
  end

  let(:response_order) {
    JSON.parse(response.body).fetch("customer_order")
  }

  it "customer address gets assigned" do
    provider_profile = response_order["provider_profiles"].first
    customer_order_delivery = provider_profile["customer_order_delivery"]
    expect(
      customer_order_delivery["customer_address_id"]
    ).to eq(customer_address.id)
    expect(
      customer_order_delivery["deliver_at"]
    ).to be_present
  end
end
