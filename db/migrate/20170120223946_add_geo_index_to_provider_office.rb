class AddGeoIndexToProviderOffice < ActiveRecord::Migration
  def change
    change_column :provider_offices, :lat, "float USING CAST(lat AS float)", null: false
    change_column :provider_offices, :lon, "float USING CAST(lon AS float)", null: false
    add_index :provider_offices, [:lat, :lon]
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
