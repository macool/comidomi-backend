# == Schema Information
#
# Table name: provider_item_images
#
#  id               :integer          not null, primary key
#  provider_item_id :integer          not null
#  imagen           :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe ProviderItemImage,
               type: :model do
  describe "factory" do
    subject { build :provider_item_image }
    it { is_expected.to be_valid }
  end
end
