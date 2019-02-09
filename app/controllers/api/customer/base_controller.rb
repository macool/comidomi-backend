module Api
  module Customer
    class BaseController < Api::BaseController
      protected

      def find_or_create_customer_profile
        @customer_profile =
          current_api_auth_user.customer_profile || current_api_auth_user.create_customer_profile
      end
    end
  end
end
