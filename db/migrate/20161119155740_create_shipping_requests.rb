class CreateShippingRequests < ActiveRecord::Migration
  def change
    create_table :shipping_requests do |t|
      t.integer :resource_id, null: false
      t.string :resource_type, null: false
      t.string :kind, null: false

      t.timestamps null: false
    end
    add_index :shipping_requests, [:resource_id, :resource_type]
  end
end
