class AddDeletedAtToProviderClient < ActiveRecord::Migration
  def change
    add_column :provider_clients,
               :deleted_at,
               :datetime
    add_index :provider_clients, :deleted_at
  end
end
