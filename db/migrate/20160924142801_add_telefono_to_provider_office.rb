class AddTelefonoToProviderOffice < ActiveRecord::Migration
  def change
    add_column :provider_offices,
               :telefono,
               :string
  end
end
