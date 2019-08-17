# == Schema Information
#
# Table name: provider_lunches
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  precio_cents        :integer          default(0), not null
#  precio_currency     :string           default("USD"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe ProviderLunch, type: :model do
  describe "factory" do
    it { expect(build(:provider_lunch)).to be_valid }
  end
end
