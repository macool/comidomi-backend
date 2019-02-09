require "rails_helper"

describe %q{
  As an admin
  I can create users
} do
  let!(:admin) { create :user, :admin }

  before { login_as_admin admin }

  feature "submit form" do
    before do
      visit new_admin_user_path
    end

    let(:attributes) {
      attributes_for(:user).slice(
        :name,
        :nickname,
        :email,
        :password,
        :password_confirmation
      )
    }

    it {
      # fill form!
      attributes.each do |key, value|
        label = I18n.t("activerecord.attributes.user.#{key}")
        fill_in label, with: value
      end

      expect {
        # submit form!
        find("input[type='submit']").click
      }.to change{ User.count }.by(1)

      expect(page).to have_content(
        I18n.t("admin.user.created")
      )
    }
  end
end
