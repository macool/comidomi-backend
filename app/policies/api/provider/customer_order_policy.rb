module Api
  module Provider
    class CustomerOrderPolicy < ::ApplicationPolicy
      class Scope < Scope
        def resolve(status = nil)
          deliveries = CustomerOrderDelivery.where(
            provider_profile_id: user.provider_profile.id
          )
          if status.present?
            deliveries = deliveries.with_status(*status)
          end
          scope.where(
            id: deliveries.pluck(:customer_order_id)
          ).with_status(:submitted)
        end
      end

      def index?
        is_provider?
      end

      def show?
        is_provider? && provider_profile_in_record?
      end

      def accept?
        is_provider? &&
          provider_profile_in_record? &&
          pending_delivery?
      end

      def reject?
        is_provider? &&
          provider_profile_in_record? &&
          pending_delivery?
      end

      private

      def is_provider?
        user.provider_profile.present?
      end

      def provider_profile_in_record?
        record.provider_profile_ids.include?(
          user.provider_profile.id
        )
      end

      def pending_delivery?
        record.delivery_for_provider(
          user.provider_profile
        ).status.pending?
      end
    end
  end
end
