# == Schema Information
#
# Table name: customer_wishlists
#
#  id                  :integer          not null, primary key
#  customer_profile_id :integer          not null
#  nombre              :string           not null
#  provider_items_ids  :text             default([]), is an Array
#  entregar_en         :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe CustomerWishlist,
               type: :model do
  describe "factory" do
    subject { build :customer_wishlist }
    it { is_expected.to be_valid }
  end
end
