class ProviderProfile < ActiveRecord::Base
  module TransitionTo
    class ValidatedService < GenericTransitionService
      def perform
        return unless valid?
        transaction do
          update_state!
        end
      end

      private

      def predicate
        :validated
      end
    end
  end
end
