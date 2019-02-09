class CreateSitePreferences < ActiveRecord::Migration
  def change
    create_table :site_preferences do |t|
      t.string :name, null: false
      t.text :content

      t.timestamps null: false
    end
    add_index :site_preferences, :name, unique: true
  end
end
