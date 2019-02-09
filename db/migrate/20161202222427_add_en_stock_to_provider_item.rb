class AddEnStockToProviderItem < ActiveRecord::Migration
  def change
    add_column :provider_items, :en_stock, :boolean
    add_index :provider_items, :en_stock
  end
end
