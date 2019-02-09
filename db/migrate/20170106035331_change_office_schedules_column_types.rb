class ChangeOfficeSchedulesColumnTypes < ActiveRecord::Migration
  def change
    remove_column :provider_office_weekdays, :hora_de_apertura
    remove_column :provider_office_weekdays, :hora_de_cierre
    add_column :provider_office_weekdays, :hora_de_apertura, :datetime
    add_column :provider_office_weekdays, :hora_de_cierre, :datetime
  end
end
