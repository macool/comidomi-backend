Devise.setup do |config|
  config.mailer_sender = "no-reply@mailing.moviggo.com"

  # If using rails-api, you may want to tell devise to not use ActionDispatch::Flash
  # middleware b/c rails-api does not include it.
  # See: http://stackoverflow.com/q/19600905/806956
  config.navigational_formats = ["*/*", :html, :json]

  # 'new' email regexp devise 4.1 onwards
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.scoped_views = true
end

Rails.application.config.to_prepare do
  Devise::SessionsController.layout "devise"
  # Devise::RegistrationsController.layout "admin"
  # Devise::ConfirmationsController.layout "devise"
  # Devise::UnlocksController.layout "devise"
  # Devise::PasswordsController.layout "devise"
end
