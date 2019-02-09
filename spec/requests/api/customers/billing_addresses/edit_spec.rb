require "rails_helper"

RSpec.describe Api::Customer::BillingAddressesController,
               type: :request do
  let(:user) { create :user, :customer }
  let(:customer_billing_address) {
    create :customer_billing_address,
           customer_profile: user.customer_profile
  }
  let(:new_attributes) {
    attributes_for(:customer_billing_address)
  }

  before do
    login_as user

    customer_billing_address

    put_with_headers(
      "/api/customer/billing_addresses/#{customer_billing_address.id}",
      new_attributes
    )
  end

  let(:response_billing_address) {
    JSON.parse(response.body).fetch("customer_billing_address")
  }

  it "attributes are updated" do
    expect(
      response_billing_address["telefono"]
    ).to eq(new_attributes[:telefono])

    expect(
      response_billing_address["direccion"]
    ).to eq(new_attributes[:direccion])
  end
end
