class CustomerOrder < ActiveRecord::Base
  class CheckoutService
    class Validator
      delegate :errors, to: :@customer_order

      def initialize(user, customer_order, submission_attributes)
        @user = user
        @customer_order = customer_order
        @submission_attributes = submission_attributes
      end

      def valid?
        valid_customer_order? &&
          valid_customer_order_items? &&
          assign_submission_attributes? &&
          required_attributes_present? &&
          valid_customer_order_deliveries?
      end

      private

      def valid_customer_order?
        unless CustomerOrderPolicy.new(@user, @customer_order).checkout?
          errors.add(:status, :invalid)
        end
        errors.empty?
      end

      def valid_customer_order_items?
        unless @customer_order.order_items.count > 0
          errors.add(:order_items, :at_least_one)
        end
        unless @customer_order.order_items.reload.all?(&:valid?)
          errors.add(:order_items, :invalid)
        end
        errors.empty?
      end

      def assign_submission_attributes?
        @customer_order.assign_attributes(@submission_attributes)
        @customer_order.valid?
      rescue ArgumentError => e
        errors.add(:base, e.message)
        false
      end

      def required_attributes_present?
        if @customer_order.forma_de_pago.blank?
          errors.add(:forma_de_pago, :blank)
        end
        if @customer_order.anon_billing_address.blank? && @customer_order.customer_billing_address_id.blank?
          errors.add(:customer_billing_address_id, :blank)
        end
        errors.empty?
      end

      def valid_customer_order_deliveries?
        @customer_order.provider_profiles.all? do |provider_profile|
          delivery = @customer_order.delivery_for_provider(
            provider_profile
          )
          if delivery.blank? || !delivery.valid? || !delivery.ready_for_submission?
            errors.add(:order_items, :missing_delivery_address)
          end
          errors.empty?
        end
      end
    end
  end
end
