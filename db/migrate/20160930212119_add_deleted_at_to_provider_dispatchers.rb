class AddDeletedAtToProviderDispatchers < ActiveRecord::Migration
  def change
    add_column :provider_dispatchers, :deleted_at, :datetime
    add_index :provider_dispatchers, :deleted_at
  end
end
