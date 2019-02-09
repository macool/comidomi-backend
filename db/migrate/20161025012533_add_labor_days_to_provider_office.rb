class AddLaborDaysToProviderOffice < ActiveRecord::Migration
  def up
    add_column :provider_offices, :inicio_de_labores, :integer
    add_column :provider_offices, :final_de_labores, :integer
  end

  def down
    remove_column :provider_offices, :inicio_de_labores
    remove_column :provider_offices, :final_de_labores
  end
end
