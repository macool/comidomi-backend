class RemoveIsGroupFromProviderItem < ActiveRecord::Migration
  def change
    remove_column :provider_items, :is_group, :boolean, default: false
  end
end
