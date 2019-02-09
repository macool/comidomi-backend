class CreateCustomerWishlists < ActiveRecord::Migration
  def change
    create_table :customer_wishlists do |t|
      t.references :customer_profile,
                   index: true,
                   foreign_key: true,
                   null: false
      t.string :nombre, null: false
      t.text :provider_items_ids, array: true, default: []
      t.datetime :entregar_en

      t.timestamps null: false
    end
  end
end
