class AddExtraInfoToProviderProfile < ActiveRecord::Migration
  def change
    add_column :provider_profiles, :logotipo, :string
    add_column :provider_profiles, :banco_tipo_cuenta, :integer
    remove_column :provider_profiles, :banco_identificacion
  end
end
