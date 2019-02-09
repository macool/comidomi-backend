class CreateCustomerOrderItems < ActiveRecord::Migration
  def change
    create_table :customer_order_items do |t|
      t.references :customer_order,
                   null: false,
                   index: true,
                   foreign_key: true
      t.references :provider_item,
                   null: false,
                   index: true,
                   foreign_key: true
      t.monetize :provider_item_precio
      t.integer :cantidad, null: false, default: 1
      t.text :observaciones

      t.timestamps null: false
    end
  end
end
