class AddOpenCloseProviderOffice < ActiveRecord::Migration
  def up
    remove_column :provider_offices, :horario
    add_column :provider_offices, :hora_de_apertura, :time
    add_column :provider_offices, :hora_de_cierre, :time
  end

  def down
    add_column :provider_offices, :horario, :string
    remove_column :provider_offices, :hora_de_apertura, :time
    remove_column :provider_offices, :hora_de_cierre, :time
  end
end
