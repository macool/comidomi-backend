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

require 'rails_helper'

RSpec.describe CustomerBillingAddress,
               type: :model do
  describe "factory" do
    subject { build :customer_billing_address }
    it { is_expected.to be_valid }
  end
end
