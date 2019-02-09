class RemoveImagenFromProviderItem < ActiveRecord::Migration
  def change
    remove_column :provider_items, :imagen, :string
  end
end
