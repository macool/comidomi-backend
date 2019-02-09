class AddReasonToCustomerOrderDelivery < ActiveRecord::Migration
  def change
    add_column :customer_order_deliveries, :reason, :text
  end
end
