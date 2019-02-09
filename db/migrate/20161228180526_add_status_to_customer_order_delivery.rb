class AddStatusToCustomerOrderDelivery < ActiveRecord::Migration
  def change
    add_column :customer_order_deliveries,
               :status,
               :string,
               null: false,
               default: CustomerOrderDelivery.status.values.first
    add_index :customer_order_deliveries, :status
  end
end
