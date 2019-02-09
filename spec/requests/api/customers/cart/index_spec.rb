require "rails_helper"

RSpec.describe Api::Customer::Cart::ItemsController,
               type: :request do
  before do
    login_as user
  end

  let(:response_order) {
    JSON.parse(response.body).fetch("customer_order")
  }

  describe "non-customer" do
    let(:user) { create :user }

    before {
      # should not create any order
      expect {
        get_with_headers "/api/customer/cart"
      }.to_not change(CustomerOrder, :count)
    }

    it "should not create any customer profile" do
      expect(
        user.customer_profile
      ).to_not be_present
    end

    it "order is empty" do
      expect(
        response_order
      ).to be_nil
    end
  end

  describe "customer with no order" do
    let(:user) { create :user, :customer }

    before {
      # should not create any order
      expect {
        get_with_headers "/api/customer/cart"
      }.to_not change(CustomerOrder, :count)
    }

    it "order is empty" do
      expect(
        response_order
      ).to be_nil
    end
  end

  describe "customer with order" do
    let(:place) { create :place, nombre: "loh" }
    let(:user) { create :user, :customer, current_place: place }
    let(:customer_order) {
      create :customer_order,
             customer_profile: user.customer_profile
    }
    let(:order_item_1) {
      create :customer_order_item,
             customer_order: customer_order
    }

    before do
      order_item_1

      get_with_headers "/api/customer/cart"
    end

    it "includes full order" do
      expect(
        response_order["subtotal_items_cents"]
      ).to eq(customer_order.subtotal_items.cents)

      response_provider = response_order["provider_profiles"].first
      expect(
        response_provider["nombre_establecimiento"]
      ).to eq(
        order_item_1.provider_item.provider_profile.nombre_establecimiento
      )

      response_item = response_provider["customer_order_items"].first
      expect(
        response_item["provider_item_precio_cents"]
      ).to eq(order_item_1.provider_item.precio.cents)

      provider_item = response_item["provider_item"]
      expect(
        provider_item["titulo"]
      ).to be_present
    end
  end
end
