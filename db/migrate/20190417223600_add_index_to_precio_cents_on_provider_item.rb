class AddIndexToPrecioCentsOnProviderItem < ActiveRecord::Migration
  def change
    add_index :provider_items, :precio_cents
  end
end
