class CreateProviderItemImages < ActiveRecord::Migration
  def change
    create_table :provider_item_images do |t|
      t.references :provider_item,
                   index: true,
                   null: false,
                   foreign_key: true
      t.string :imagen, null: false
      t.timestamps null: false
    end
  end
end
