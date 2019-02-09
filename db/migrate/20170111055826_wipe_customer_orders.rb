class WipeCustomerOrders < ActiveRecord::Migration
  def up
    say "WARNING: wiping all customer orders"
    CustomerOrderDelivery.delete_all
    CustomerOrderItem.delete_all
    CustomerOrder.delete_all
  end

  def down
    say "doing nothing.."
  end
end
