class AddParentProviderItemToProviderItem < ActiveRecord::Migration
  def change
    add_reference :provider_items, :parent_provider_item, index: true
    add_foreign_key :provider_items, :provider_items, column: :parent_provider_item_id
    add_column :provider_items, :is_group, :boolean, default: false
    add_index :provider_items, :is_group
  end
end
