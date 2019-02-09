require "rails_helper"

RSpec.describe Api::Customer::OrdersController,
               type: :request do
  let(:user) { create :user, :customer }
  before { login_as user }
  let(:customer_order) {
    create :customer_order,
           :submitted,
           customer_profile: user.customer_profile
  }

  describe "I can cancel a recent order" do
    it {
      delivery = create(
        :customer_order_delivery,
        customer_order: customer_order,
        status: :accepted,
        provider_responded_at: Time.now
      )
      post_with_headers(
        "/api/customer/orders/#{customer_order.id}/deliveries/#{delivery.id}/cancel"
      )
      response_delivery = JSON.parse(
        response.body
      ).fetch("customer_order_delivery")
      expect(response_delivery["status"]).to eq("canceled")
    }
  end

  describe "I can't cancel an old order" do
    it {
      delivery = create(
        :customer_order_delivery,
        customer_order: customer_order,
        status: :accepted,
        provider_responded_at: 15.minutes.ago
      )
      post_with_headers(
        "/api/customer/orders/#{customer_order.id}/deliveries/#{delivery.id}/cancel"
      )
      response_errors = JSON.parse(response.body).fetch("errors")
      expect(response_errors["base"].length).to eq(1)
    }
  end
end
