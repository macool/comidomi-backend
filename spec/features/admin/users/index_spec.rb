require "rails_helper"

describe %q{
  as admin
  I see users
} do
  let!(:admin) { create :user, :admin }
  before { login_as_admin admin }

  feature "users in document" do
    let(:user) { create :user }

    before {
      user
      visit admin_users_path
    }

    it {
      expect(page).to have_content(user.name)
    }
  end
end
