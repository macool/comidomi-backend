class CreateCustomerOrders < ActiveRecord::Migration
  def change
    create_table :customer_orders do |t|
      t.integer :status, null: false, default: 0
      t.monetize :subtotal_items
      t.references :customer_profile,
                   index: true,
                   foreign_key: true

      t.timestamps null: false
    end
    add_index :customer_orders, :status
  end
end
