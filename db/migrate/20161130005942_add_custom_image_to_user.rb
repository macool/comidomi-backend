class AddCustomImageToUser < ActiveRecord::Migration
  def change
    add_column :users, :custom_image, :string
  end
end
