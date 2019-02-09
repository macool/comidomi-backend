class CreateCustomerOrderDeliveries < ActiveRecord::Migration
  def change
    create_table :customer_order_deliveries do |t|
      t.datetime :deliver_at
      t.string :delivery_method, null: false
      t.references :customer_address, index: true, foreign_key: true
      t.json :customer_address_attributes
      t.references :provider_profile, index: true, foreign_key: true
      t.references :customer_order, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
