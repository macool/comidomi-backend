class CreateProviderLunchItems < ActiveRecord::Migration
  def change
    create_table :provider_lunch_items do |t|
      t.references :provider_lunch, index: true, foreign_key: true, null: false
      t.string :kind, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
