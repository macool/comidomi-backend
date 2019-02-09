class AddDeletedAtToProviderItem < ActiveRecord::Migration
  def change
    add_column :provider_items, :deleted_at, :datetime
    add_index :provider_items, :deleted_at
  end
end
