class MigrateCourierProfileEnums < ActiveRecord::Migration
  def change
    change_table :courier_profiles do |t|
      t.change :tipo_licencia, :string
      t.change :tipo_medio_movilizacion, :string
    end
  end
end
