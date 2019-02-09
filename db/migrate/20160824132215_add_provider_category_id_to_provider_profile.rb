class AddProviderCategoryIdToProviderProfile < ActiveRecord::Migration
  def change
    add_reference :provider_profiles,
                  :provider_category,
                  index: true,
                  foreign_key: true
  end
end
