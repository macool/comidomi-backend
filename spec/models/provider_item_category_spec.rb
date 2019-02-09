# == Schema Information
#
# Table name: provider_item_categories
#
#  id                  :integer          not null, primary key
#  nombre              :string
#  predeterminada      :boolean          default(FALSE)
#  provider_profile_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe ProviderItemCategory,
               type: :model do
  describe "factory" do
    subject { build :provider_item_category }
    it { is_expected.to be_valid }
  end
end
