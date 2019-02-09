class AddStatusToProviderProfile < ActiveRecord::Migration
  def change
    add_column :provider_profiles, :status, :integer, default: 0
    add_index :provider_profiles, :status
  end
end
