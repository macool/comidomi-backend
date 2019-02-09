module Api
  module Provider
    class BaseController < Api::BaseController
      module ResourceCollectionable
        extend ActiveSupport::Concern

        def index
          pundit_authorize
          @api_collection = resource_scope
        end
      end
    end
  end
end
