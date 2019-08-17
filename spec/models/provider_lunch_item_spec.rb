# == Schema Information
#
# Table name: provider_lunch_items
#
#  id                :integer          not null, primary key
#  provider_lunch_id :integer          not null
#  kind              :string           not null
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe ProviderLunchItem, type: :model do
  describe "factory" do
    it { expect(build(:provider_lunch_item)).to be_valid }
  end
end
