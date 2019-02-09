class RemoveOldProviderOfficeWeekdayFields < ActiveRecord::Migration
  def change
    remove_column :provider_offices, :hora_de_apertura
    remove_column :provider_offices, :hora_de_cierre
    remove_column :provider_offices, :inicio_de_labores
    remove_column :provider_offices, :final_de_labores
  end
end
