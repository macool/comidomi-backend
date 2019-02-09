class MigrateProviderOfficeToPlace < ActiveRecord::Migration
  def change
    remove_column :provider_offices, :ciudad, :string
    add_reference :provider_offices, :place, index: true, foreign_key: true
  end
end
