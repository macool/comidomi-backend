class CreateShippingFares < ActiveRecord::Migration
  def change
    create_table :shipping_fares do |t|
      t.references :place, index: true, foreign_key: true, null: false
      t.monetize :price, null: false

      t.timestamps null: false
    end
  end
end
