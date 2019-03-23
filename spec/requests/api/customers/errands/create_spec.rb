require "rails_helper"

RSpec.describe Api::Customer::ErrandsController, type: :request do
  describe "creates customer errand" do
    let(:user) { create :user }
    before { login_as user }

    let(:errand_description) { Faker::Hipster.paragraphs.join "\n" }

    it "sets description" do
      expect {
        post_with_headers(
          "/api/customer/errands",
          description: errand_description
        )
      }.to change{ CustomerErrand.count }.by(1)

      created_errand = CustomerErrand.last
      expect(created_errand.description).to eq(errand_description)
      expect(created_errand.customer_profile).to eq(user.customer_profile)
    end

    it "generates shipping request" do
      expect {
        post_with_headers(
          "/api/customer/errands",
          description: errand_description
        )
      }.to change{ ShippingRequest.count }.by(1)

      created_shipping_req = ShippingRequest.last
      expect(created_shipping_req.resource_type).to eq("CustomerErrand")
    end
  end
end
