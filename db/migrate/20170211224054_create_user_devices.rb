class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :platform, null: false
      t.string :uuid, null: false
      t.timestamps null: false
    end
    add_index :user_devices, [:platform, :uuid]
  end
end
