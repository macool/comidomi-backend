require "rails_helper"

RSpec.describe Api::Customer::Cart::ItemsController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "adds an item to the cart" do
    let(:provider_item) { create :provider_item }
    let(:posted_attributes) {
      attributes_for(:customer_order_item)
    }

    let(:customer_order) {
      JSON.parse(response.body).fetch("customer_order")
    }

    before do
      provider_item

      expect {
        post_with_headers(
          "/api/customer/cart/items",
          posted_attributes.merge(
            provider_item_id: provider_item.id
          )
        )
      }.to change { CustomerOrder.count }.by(1)
    end

    it "customer_profile gets automatically created" do
      customer_profile = user.reload.customer_profile
      expect(customer_profile).to be_present
      expect(customer_profile).to be_persisted
    end

    it "should create right order_item" do
      customer_order = CustomerOrder.last
      order_items = customer_order.order_items

      expect(
        customer_order.customer_profile
      ).to eq(user.customer_profile)

      expect(
        order_items.count
      ).to eq(1)

      expect(
        order_items.first.cantidad
      ).to eq(posted_attributes[:cantidad])
    end

    it "should render whole order" do
      provider_profile = customer_order["provider_profiles"].first
      customer_order_item = provider_profile["customer_order_items"].first

      expect(
        customer_order
      ).to have_key("status")

      expect(
        customer_order
      ).to have_key("subtotal_items_cents")

      expect(
        customer_order_item
      ).to have_key("cantidad")

      expect(
        customer_order_item
      ).to have_key("observaciones")
    end

    it "order subtotal should be updated" do
      subtotal = posted_attributes[:cantidad] * provider_item.precio

      expect(
        customer_order["subtotal_items_cents"]
      ).to eq(subtotal.cents)
    end

    it "delivery gets automatically created" do
      provider_profile = customer_order["provider_profiles"].first
      expect(
        provider_profile["customer_order_delivery"]["id"]
      ).to be_present
    end
  end

  describe "add an item which already is in the cart" do
    let(:user) { create :user, :customer }
    let(:customer_order) {
      create :customer_order,
             customer_profile: user.customer_profile
    }
    let(:existing_item) {
      create :customer_order_item,
             cantidad: 3,
             customer_order: customer_order
    }
    let(:posted_attributes) {
      attributes_for :customer_order_item,
                     provider_item_id: existing_item.provider_item_id
    }

    before do
      existing_item
      expect {
        post_with_headers "/api/customer/cart/items", posted_attributes
      }.to_not change(CustomerOrderItem, :count)
    end

    it "updates customer order item" do
      existing_item.reload

      expect(
        existing_item.cantidad
      ).to eq(3 + posted_attributes[:cantidad])

      expect(
        existing_item.observaciones
      ).to include(
        "\n" + posted_attributes[:observaciones]
      )
    end
  end
end
