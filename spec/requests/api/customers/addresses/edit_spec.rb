require "rails_helper"

RSpec.describe Api::Customer::AddressesController,
               type: :request do
  let(:user) { create :user, :customer }
  let(:customer_address) {
    create :customer_address,
           customer_profile: user.customer_profile
  }
  let(:new_attributes) { attributes_for(:customer_address) }

  before do
    login_as user

    customer_address

    put_with_headers(
      "/api/customer/addresses/#{customer_address.id}",
      new_attributes
    )
  end

  let(:response_address) {
    JSON.parse(response.body).fetch("customer_address")
  }

  it "attributes are updated" do
    expect(
      response_address["codigo_postal"]
    ).to eq(new_attributes[:codigo_postal])

    expect(
      response_address["numero_convencional"]
    ).to eq(new_attributes[:numero_convencional])
  end
end
