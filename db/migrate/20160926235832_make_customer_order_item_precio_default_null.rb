class MakeCustomerOrderItemPrecioDefaultNull < ActiveRecord::Migration
  def up
    change_table :customer_order_items do |t|
      t.change :provider_item_precio_cents,
               :integer,
               null: true,
               default: :null
    end
  end

  def down
    change_table :customer_order_items do |t|
      t.change :provider_item_precio_cents,
               :integer,
               default: 0,
               null: false
    end
  end
end
