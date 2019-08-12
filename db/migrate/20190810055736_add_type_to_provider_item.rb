class AddTypeToProviderItem < ActiveRecord::Migration
  def change
    add_column :provider_items, :type, :string, null: false, default: 'ProviderItemSingle'
    add_index :provider_items, :type
  end
end
