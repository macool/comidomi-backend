# == Schema Information
#
# Table name: provider_clients
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer
#  notas               :text
#  ruc                 :string
#  nombres             :string
#  direccion           :string
#  telefono            :string
#  email               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deleted_at          :datetime
#

class ProviderClient < ActiveRecord::Base
  include SoftDestroyable

  begin :relationships
    belongs_to :provider_profile
  end

  begin :validations
    validates :provider_profile_id,
              :ruc,
              :nombres,
              :direccion,
              :telefono,
              :email,
              presence: true
  end
end
