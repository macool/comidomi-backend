# == Schema Information
#
# Table name: places
#
#  id                  :integer          not null, primary key
#  lat                 :string
#  lon                 :string
#  nombre              :string           not null
#  country             :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  price_per_km_cents  :integer          default(1)
#  factor_per_distance :float            default(0.1)
#  enabled             :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Place,
               type: :model do
  describe "factory" do
    subject { build :place }
    it { is_expected.to be_valid }
  end
end
