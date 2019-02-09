class MigrateCustomerOrdersToDeliverToMultipleAddresses < ActiveRecord::Migration
  def up
    say "WARNING: wiping all customer orders"
    CustomerOrderItem.delete_all
    CustomerOrder.destroy_all
    change_table :customer_orders do |t|
      t.remove :deliver_at,
               :delivery_method,
               :customer_address_id,
               :customer_address_attributes
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
