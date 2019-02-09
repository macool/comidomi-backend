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

  let(:new_cantidad) {
    order_item_1.cantidad + 2
  }

  before do
    login_as user

    # add items to my cart
    order_item_1
    order_item_2

    # and update one of them
    put_with_headers(
      "/api/customer/cart/items/#{order_item_1.id}",
      cantidad: new_cantidad
    )
  end

  let(:response_order) {
    JSON.parse(response.body).fetch("customer_order")
  }

  it "order item gets updated" do
    provider_profile = response_order["provider_profiles"].first
    response_order_item = provider_profile["customer_order_items"].detect do |oi|
      oi["id"] == order_item_1.id
    end

    expect(
      response_order_item["cantidad"]
    ).to eq(new_cantidad)
  end

  it "order subtotal gets updated" do
    subtotal = order_item_1.provider_item_precio * new_cantidad
    subtotal += order_item_2.subtotal

    expect(
      response_order["subtotal_items_cents"]
    ).to eq(subtotal.cents)
  end
end
