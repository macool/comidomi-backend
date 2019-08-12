class MigrateGroupsToTypesOnProviderItem < ActiveRecord::Migration
  def change
    ProviderItem.where(is_group: true).find_each do |provider_item|
      provider_item.update! type: "ProviderItemGroup"
    end
  end
end
