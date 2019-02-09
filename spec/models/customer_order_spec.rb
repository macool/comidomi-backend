# == Schema Information
#
# Table name: customer_orders
#
#  id                                  :integer          not null, primary key
#  status                              :string           default("in_progress"), not null
#  subtotal_items_cents                :integer          default(0), not null
#  subtotal_items_currency             :string           default("USD"), not null
#  customer_profile_id                 :integer          not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  forma_de_pago                       :string
#  observaciones                       :text
#  customer_billing_address_attributes :text
#  customer_billing_address_id         :integer
#  submitted_at                        :datetime
#  anon_billing_address                :boolean          default(FALSE)
#  place_id                            :integer
#

require 'rails_helper'

RSpec.describe CustomerOrder,
               type: :model do
  describe "factory" do
    subject { build :customer_order }
    it { is_expected.to be_valid }
    it "default status" do
      expect(subject.status).to be_in_progress
    end
  end

  describe "#in_progress scope" do
    let(:customer_order_in_progress) {
      create :customer_order, status: :in_progress
    }

    let(:customer_order_submitted) {
      create :customer_order, status: :submitted
    }

    before do
      customer_order_submitted
      customer_order_in_progress
    end

    subject { described_class.with_status(:in_progress) }

    it {
      is_expected.to include(customer_order_in_progress)
      is_expected.to_not include(customer_order_submitted)
    }
  end

  describe "#submit - upon submission" do
    let(:customer_order) {
      create :customer_order,
             :with_customer_billing_address
    }
    let(:customer_order_item) {
      create :customer_order_item,
             customer_order: customer_order
    }

    describe "caches #subtotal_items" do
      before do
        customer_order_item
        CustomerOrder::CheckoutService::Submitter.new(
          customer_order
        ).submit_order!
      end

      it {
        expect(
          customer_order[:subtotal_items_cents]
        ).to be_present

        expect(
          customer_order.subtotal_items
        ).to eq(customer_order_item.subtotal)
      }
    end

    describe "caches order_items #provider_item_precio" do
      let(:provider_item) {
        customer_order_item.provider_item
      }
      let(:old_price) {
        provider_item.precio
      }

      before do
        old_price
        CustomerOrder::CheckoutService::Submitter.new(
          customer_order
        ).submit_order!
        # update price
        provider_item.update!(
          precio: provider_item.precio + Money.from_amount(1.99, "USD")
        )
      end

      it {
        expect(
          customer_order_item.reload[:provider_item_precio_cents]
        ).to be_present

        expect(
          customer_order_item.provider_item_precio
        ).to eq(old_price)
      }
    end
  end
end
