class AddShippingFarePriceToCustomerOrderDelivery < ActiveRecord::Migration
  def change
    add_column :customer_order_deliveries, :shipping_fare_price_cents, :integer
  end
end
