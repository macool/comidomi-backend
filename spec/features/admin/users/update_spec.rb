require "rails_helper"

describe %q{
  As an admin
  I can edit users
} do
  let!(:admin) { create :user, :admin }

  before { login_as_admin admin }

  feature "submitting form" do
    let!(:user) { create :user }

    before do
      visit edit_admin_user_path(user)
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

      # submit form!
      find("input[type='submit']").click

      expect(user.reload.name).to eq(attributes[:name])

      expect(page).to have_content(
        I18n.t("admin.user.updated")
      )
    }
  end
end
