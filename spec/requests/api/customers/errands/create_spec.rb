require "rails_helper"

RSpec.describe Api::Customer::ErrandsController, type: :request do
  describe "creates customer errand" do
    let(:user) { create :user, :customer }

    let(:shipping_fare) {
      create :shipping_fare, place: user.current_place
    }

    let(:customer_address) {
      create :customer_address, customer_profile: user.customer_profile
    }

    let(:parameters) {
      {
        customer_address_id: customer_address.id,
        description: Faker::Hipster.paragraphs.join("\n")
      }
    }

    before {
      shipping_fare
      login_as user
    }

    it "sets description" do
      expect {
        post_with_headers("/api/customer/errands", parameters)
      }.to change{ CustomerErrand.count }.by(1)

      resp_errand = JSON.parse(response.body)["customer_errand"]
      expect(resp_errand["description"]).to eq(parameters[:description])
      expect(resp_errand["shipping_fare_price_cents"]).to eq(shipping_fare.price_cents)
      expect(
        CustomerErrand.find(resp_errand["id"]).customer_profile
      ).to eq(user.customer_profile)
    end

    it "generates shipping request" do
      expect {
        post_with_headers("/api/customer/errands", parameters)
      }.to change{ ShippingRequest.count }.by(1)

      created_shipping_req = ShippingRequest.last
      expect(created_shipping_req.resource_type).to eq("CustomerErrand")
    end
  end
end
