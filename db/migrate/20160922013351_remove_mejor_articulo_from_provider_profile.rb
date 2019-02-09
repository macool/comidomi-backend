class RemoveMejorArticuloFromProviderProfile < ActiveRecord::Migration
  def change
    remove_column :provider_profiles, :mejor_articulo, :string
  end
end
