class MigrateProviderOfficeCiudadToStringEnum < ActiveRecord::Migration
  def up
    say_with_time "WARNING: wiping all ciudades in provider offices" do
      remove_column :provider_offices, :ciudad
      add_column :provider_offices, :ciudad, :string
    end
  end

  def down
    remove_column :provider_offices, :ciudad
    add_column :provider_offices, :ciudad, :integer
  end
end
