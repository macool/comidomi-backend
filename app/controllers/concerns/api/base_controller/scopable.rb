module Api
  class BaseController < ::ApplicationController
    module Scopable
      extend ActiveSupport::Concern

      included do
        cattr_accessor :resource_klass
      end

      protected

      def resource_scope
        policy_scope(resource_klass)
      end

      def pundit_authorize
        authorize(resource_klass)
      end
    end
  end
end
