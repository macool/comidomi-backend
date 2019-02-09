class ApplicationController < ActionController::Base
  include Devisable
  include Punditable
  include PaperTrailable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error
  add_flash_types :success
end
