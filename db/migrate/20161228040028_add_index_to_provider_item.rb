class AddIndexToProviderItem < ActiveRecord::Migration
  def change
    add_index :provider_items, :cantidad
  end
end
