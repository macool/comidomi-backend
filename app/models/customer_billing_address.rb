# == Schema Information
#
# Table name: customer_billing_addresses
#
#  id                  :integer          not null, primary key
#  customer_profile_id :integer          not null
#  ciudad              :string
#  telefono            :string
#  email               :string
#  ruc                 :string           not null
#  razon_social        :string           not null
#  direccion           :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CustomerBillingAddress < ActiveRecord::Base
  belongs_to :customer_profile

  validates :ruc,
            :direccion,
            :razon_social,
            presence: true
end
