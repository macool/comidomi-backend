class CustomerOrderDelivery < ActiveRecord::Base
  class ShippingCostCalculatorService
    class ShippingFareMatcher
      def initialize(options)
        @place = options.fetch(:place)
        @price_cents = options.fetch(:price_cents).round
      end

      def shipping_fare
        exact_fare.presence || ceil_fare.presence || biggest_fare
      end

      private

      def exact_fare
        @place.shipping_fares.find_by(price_cents: @price_cents)
      end

      def ceil_fare
        @place.shipping_fares.by_ceil_price_cents(@price_cents).smaller.first
      end

      def biggest_fare
        @place.shipping_fares.bigger.first
      end
    end
  end
end
