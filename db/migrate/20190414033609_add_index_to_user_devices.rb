class AddIndexToUserDevices < ActiveRecord::Migration
  def up
    add_index :user_devices, [:platform, :user_id]
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
