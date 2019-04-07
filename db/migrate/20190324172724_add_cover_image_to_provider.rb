class AddCoverImageToProvider < ActiveRecord::Migration
  def change
    add_column :provider_profiles, :cover, :string
  end
end
