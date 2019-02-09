require "rails_helper"

RSpec.describe Api::Customer::BillingAddressesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "creates a customer billing address" do
    let(:attributes) {
      attributes_for :customer_billing_address
    }

    before do
      expect {
        post_with_headers(
          "/api/customer/billing_addresses",
          attributes
        )
      }.to change { CustomerBillingAddress.count }.by(1)
    end

    let(:resp_customer_billing_address) {
      JSON.parse(response.body).fetch("customer_billing_address")
    }

    it "customer_profile gets automatically created" do
      customer_profile = user.reload.customer_profile
      expect(customer_profile).to be_persisted
    end

    it "customer_billing_address has the attributes set" do
      expect(
        resp_customer_billing_address["direccion"]
      ).to eq(attributes[:direccion])

      expect(
        resp_customer_billing_address["ciudad"]
      ).to eq(attributes[:ciudad])
    end

    it "belongs to the right customer_profile" do
      customer_billing_address = CustomerBillingAddress.last
      expect(
        customer_billing_address.customer_profile
      ).to eq(user.reload.customer_profile)
    end
  end
end
