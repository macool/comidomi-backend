class AddStatusToProviderCategory < ActiveRecord::Migration
  def change
    add_column :provider_categories,
               :status,
               :string,
               null: false,
               default: ProviderCategory.status.values.first
    add_index :provider_categories, :status
  end
end
