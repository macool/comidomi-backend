class CreateProviderItemCategories < ActiveRecord::Migration
  def change
    create_table :provider_item_categories do |t|
      t.string :nombre
      t.boolean :predeterminada,
                default: false,
                index: true
      t.references :provider_profile,
                   index: true,
                   foreign_key: true

      t.timestamps null: false
    end
  end
end
