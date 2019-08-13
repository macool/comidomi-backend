class CreateProviderItemGroupWeekdays < ActiveRecord::Migration
  def change
    create_table :provider_item_promo_weekdays do |t|
      t.references :provider_item_promo, index: true, null: false
      t.string :wkday, null: false
      t.boolean :available, default: false
    end
    add_foreign_key :provider_item_promo_weekdays, :provider_items, column: :provider_item_promo_id
  end
end
