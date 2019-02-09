class MigrateCustomerOrderEnums < ActiveRecord::Migration
  def up
    say_with_time "WARNING: wiping all customer orders" do
      CustomerOrderItem.delete_all
      CustomerOrder.delete_all
    end

    change_table :customer_orders do |t|
      t.change :status, :string, default: CustomerOrder.status.values.first
      t.change :forma_de_pago, :string
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
