class MakeCustomerIdRequired < ActiveRecord::Migration
  def up
    CustomerOrder.where(customer_profile_id: nil).destroy_all
    change_column_null :customer_orders, :customer_profile_id, false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
