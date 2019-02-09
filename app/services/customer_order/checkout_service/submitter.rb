class CustomerOrder < ActiveRecord::Base
  class CheckoutService
    class Submitter
      def initialize(customer_order)
        @customer_order = customer_order
      end

      ##
      # transitions to submitted state
      # and caches:
      #  - subtotal_items
      #  - customer_billing_address
      # @return [Boolean] wether it was
      #   submitted or not
      def submit_order!
        @customer_order.transaction do
          cache_addresses!
          mark_deliveries_as_pending!
          cache_billing_address! unless @customer_order.anon_billing_address?
          update_subtotal_items!
          assign_submitted_at!
          submitted!
        end
      end

      private

      def cache_addresses!
        @customer_order.deliveries.each do |delivery|
          delivery.send :cache_address!
          delivery.send :cache_shipping_fare_price_cents!
        end
      end

      def mark_deliveries_as_pending!
        @customer_order.deliveries.each do |delivery|
          delivery.assign_attributes status: :pending
        end
      end

      def cache_billing_address!
        customer_billing_address = @customer_order.customer_billing_address
        @customer_order.assign_attributes(
          customer_billing_address_attributes: customer_billing_address.attributes
        )
      end

      ##
      # caches subtotal_items
      # and caches each order_item's provider_item_precio
      # @see #cache_subtotal_items!
      def update_subtotal_items!
        subtotal = @customer_order.order_items.collect do |order_item|
          order_item.cache_provider_item_precio!
          order_item.subtotal
        end.sum
        @customer_order.assign_attributes(
          subtotal_items: subtotal
        )
      end

      ##
      # writes submitted_at with current time
      def assign_submitted_at!
        @customer_order.assign_attributes(
          submitted_at: Time.now
        )
      end

      ##
      # updates state
      def submitted!
        predicate = :submitted
        @customer_order.paper_trail_event = predicate
        @customer_order.update!(status: predicate).tap do |_|
          @customer_order.paper_trail_event = nil
        end
      end
    end
  end
end
