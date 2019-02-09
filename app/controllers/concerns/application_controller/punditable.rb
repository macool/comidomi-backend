class ApplicationController < ActionController::Base
  module Punditable
    extend ActiveSupport::Concern

    included do
      include Pundit

      rescue_from Pundit::NotAuthorizedError,
                  with: :user_not_authorized
    end

    protected

    def user_not_authorized
      flash[:error] = I18n.t("pundit.not_authorized")
      redirect_to(request.referrer || root_path)
    end
  end
end
