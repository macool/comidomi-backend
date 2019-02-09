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
           customer_order: customer_order
  }
  let(:order_item_2) {
    create :customer_order_item,
           customer_order: customer_order
  }

  before do
    login_as user

    # add items to my cart
    order_item_1
    order_item_2

    # gonna substract 1 item from my cart
    expect {
      # remove one of them
      post_with_headers(
        "/api/customer/cart/items/#{order_item_2.id}",
        "_method" => "DELETE"
      )
    }.to change { customer_order.order_items.count }.by(-1)
  end

  let(:response_order) {
    JSON.parse(response.body).fetch("customer_order")
  }

  it "order subtotal gets updated" do
    expect(
      response_order["subtotal_items_cents"]
    ).to eq(order_item_1.subtotal.cents)
  end

  it "delivery gets removed" do
    expect(
      customer_order.reload.deliveries.count
    ).to eq(1)
  end
end
