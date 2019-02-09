module Api
  module Customer
    class BaseController < Api::BaseController
      module ResourceCollectionable
        def index
          pundit_authorize
          if current_api_auth_user.customer_profile
            @api_collection = collection_scope
          else
            skip_policy_scope
          end
        end

        protected

        ##
        # so that we can override this scope
        # in controllers
        def collection_scope
          resource_scope
        end
      end
    end
  end
end
