require "rails_helper"

RSpec.describe Api::Customer::AddressesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "creates a customer (delivery) address" do
    let(:attributes) { attributes_for :customer_address }

    before do
      expect {
        post_with_headers(
          "/api/customer/addresses",
          attributes
        )
      }.to change { CustomerAddress.count }.by(1)
    end

    let(:resp_customer_address) {
      JSON.parse(response.body).fetch("customer_address")
    }

    it "customer_profile gets automatically created" do
      customer_profile = user.reload.customer_profile
      expect(customer_profile).to be_persisted
    end

    it "customer_address has the attributes set" do
      expect(
        resp_customer_address["direccion_uno"]
      ).to eq(attributes[:direccion_uno])

      expect(
        resp_customer_address["referencia"]
      ).to eq(attributes[:referencia])
    end

    it "belongs to the right customer_profile" do
      customer_address = CustomerAddress.last
      expect(
        customer_address.customer_profile
      ).to eq(user.reload.customer_profile)
    end
  end
end
