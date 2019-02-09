class AddEnabledToPlace < ActiveRecord::Migration
  def change
    add_column :places, :enabled, :boolean, default: false
    add_index :places, :enabled
  end
end
