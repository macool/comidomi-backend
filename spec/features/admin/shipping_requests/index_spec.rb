require "rails_helper"

describe %q{
  As atención al cliente
  I can see shipping requests
} do
  let(:user) { create :user, :customer_service }
  before {
    user
    login_as_admin user
  }

  feature "shipping requests list" do
    let(:shipping_request) {
      create :shipping_request,
             :with_address_attributes,
             resource: build(:provider_profile)
    }
    before {
      shipping_request
      visit admin_shipping_requests_path
    }
    it {
      expect(page).to have_content(
        shipping_request.resource.nombre_establecimiento
      )
    }
  end
end
