module Api
  class BaseController < ::ApplicationController
    module JsonRequestsForgeryBypass
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token,
                           if: :json_request?
      end

      protected

      def json_request?
        content_type.present? && content_type.include?("application/json")
      end

      def content_type
        request.headers["Accept"] || request.headers["Content-Type"]
      end
    end
  end
end
