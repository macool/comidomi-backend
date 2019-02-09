class AddLatLonToProviderOffice < ActiveRecord::Migration
  def change
    add_column :provider_offices, :lat, :string
    add_column :provider_offices, :lon, :string
  end
end
