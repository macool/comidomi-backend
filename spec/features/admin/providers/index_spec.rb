require "rails_helper"

describe %q{
  As atención al cliente
  I can see provider applications
} do
  let(:user) { create :user, :customer_service }
  before {
    user
    login_as_admin user
  }

  feature "provider profile applications list" do
    let(:provider_profile) { create :provider_profile }

    before {
      provider_profile
      visit admin_provider_profiles_path(status: :applied)
    }

    it {
      expect(page).to have_content(
        provider_profile.nombre_establecimiento
      )
    }
  end
end
