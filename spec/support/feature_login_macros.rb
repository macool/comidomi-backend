module FeatureLoginMacros
  def login_as_admin(user)
    email = I18n.t("activerecord.attributes.user.email")
    password = I18n.t("activerecord.attributes.user.password")
    submit_button = I18n.t("devise.sessions.submit")

    visit new_admin_session_path
    fill_in email, with: user.email
    fill_in password, with: user.password
    click_button submit_button
  end
end
