# == Schema Information
#
# Table name: customer_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe CustomerProfile,
               type: :model do
  describe "factory" do
    subject { build :customer_profile }
    it { is_expected.to be_valid }
  end

  describe "#current_order" do
    let(:customer_profile) { create :customer_profile }

    describe "returns an order in progress if any" do
      let(:customer_order) {
        create :customer_order,
               status: :in_progress,
               customer_profile: customer_profile
      }

      before { customer_order }

      subject { customer_profile.current_order }

      it { is_expected.to eq(customer_order) }
    end

    describe "returns a new order if none in progress" do
      let(:other_customer_order) {
        create :customer_order, status: :in_progress
      }

      before { other_customer_order }

      subject { customer_profile.current_order }

      it { is_expected.to_not be_present }
    end
  end
end
