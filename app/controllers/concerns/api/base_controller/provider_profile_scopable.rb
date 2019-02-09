module Api
  class BaseController < ::ApplicationController
    module ProviderProfileScopable
      extend ActiveSupport::Concern

      included do
        helper_method :visible_provider_profiles
      end

      protected

      def visible_provider_profiles(scoped)
        Api::ProviderProfilePolicy::PublicScope.new(
          pundit_user,
          scoped
        ).resolve
      end
    end
  end
end
