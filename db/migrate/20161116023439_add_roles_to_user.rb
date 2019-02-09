class AddRolesToUser < ActiveRecord::Migration
  def up
    add_column :users, :privileges, :text, array: true, default: []
    User.reset_column_information
    User.find_each do |user|
      if user.admin?
        user.privileges << :admin
        user.save
      end
    end
    remove_column :users, :admin, :boolean
  end

  def down
    add_column :users, :admin, :boolean, default: false
    remove_column :users, :privileges
  end
end
