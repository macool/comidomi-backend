class AddProviderItemCategoryIdToProviderItem < ActiveRecord::Migration
  def change
    add_reference :provider_items,
                  :provider_item_category,
                  index: true,
                  foreign_key: true
  end
end
