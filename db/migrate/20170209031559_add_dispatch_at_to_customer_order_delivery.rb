class AddDispatchAtToCustomerOrderDelivery < ActiveRecord::Migration
  def change
    add_column :customer_order_deliveries, :dispatch_at, :datetime
  end
end
