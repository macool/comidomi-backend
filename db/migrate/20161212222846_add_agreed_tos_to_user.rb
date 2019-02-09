class AddAgreedTosToUser < ActiveRecord::Migration
  def change
    add_column :users, :agreed_tos, :boolean, default: false
  end
end
