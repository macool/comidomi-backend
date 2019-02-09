# == Schema Information
#
# Table name: customer_order_items
#
#  id                            :integer          not null, primary key
#  customer_order_id             :integer          not null
#  provider_item_id              :integer          not null
#  provider_item_precio_cents    :integer
#  provider_item_precio_currency :string           default("USD"), not null
#  cantidad                      :integer          default(1), not null
#  observaciones                 :text
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

require 'rails_helper'

RSpec.describe CustomerOrderItem,
               type: :model do
  describe "factory" do
    subject { build :customer_order_item }
    it { is_expected.to be_valid }
  end

  describe "allows saving without caching provider item precio" do
    subject { create :customer_order_item }
    it {
      expect(
        subject[:provider_item_precio_cents]
      ).to_not be_present
    }
  end

  describe "#provider_item_precio" do
    describe "order not submitted, value calculated" do
      let(:customer_order) { create :customer_order }
      let(:order_item) {
        create :customer_order_item,
               customer_order: customer_order
      }
      let(:provider_item) { order_item.provider_item }

      it {
        expect(
          order_item.provider_item_precio
        ).to eq(provider_item.precio)

        expect(
          order_item.reload[:provider_item_precio_cents]
        ).to_not be_present
      }
    end

    describe "when order is submitted and value is cached" do
      let(:customer_order) {
        create :customer_order,
               :with_customer_billing_address
      }
      let(:order_item) {
        create :customer_order_item,
               customer_order: customer_order
      }
      let(:provider_item) { order_item.provider_item }
      let(:new_price) {
        provider_item.precio + Money.from_amount(1.99, "USD")
      }

      before do
        order_item
        CustomerOrder::CheckoutService::Submitter.new(
          customer_order
        ).submit_order!
        # and then update item's precio so we
        # verify cached version doesn't change
        provider_item.update! precio: new_price
      end

      it {
        expect(
          order_item.reload[:provider_item_precio_cents]
        ).to be_present

        expect(
          order_item.provider_item_precio
        ).to_not eq(new_price)
      }
    end
  end

  describe "updates customer_order #subtotal_items" do
    let(:customer_order) {
      customer_order_item.customer_order
    }

    describe "upon creation" do
      let(:customer_order_item) {
        create :customer_order_item
      }

      it {
        subtotal = customer_order_item.cantidad * customer_order_item.provider_item_precio

        # should be cached
        expect(
          customer_order[:subtotal_items_cents]
        ).to be_present

        expect(
          customer_order.subtotal_items
        ).to eq(subtotal)
      }
    end

    describe "upon edition" do
      let(:customer_order_item) {
        create :customer_order_item
      }
      let(:older_order_item) {
        create :customer_order_item,
               customer_order: customer_order
      }

      before do
        older_order_item

        ##
        # HACK added so that order_items is always fresh.
        # see CustomerOrderItem#cache_subtotal_items!
        # CustomerOrderItem.to_s
        # def to_s
        #   "#{cantidad}x #{provider_item.descripcion} (#{provider_item.precio}): #{subtotal}"
        # end
        # puts "older: #{older_order_item}"
        # puts "new: #{customer_order_item}"
        # puts "total: #{customer_order.subtotal_items}"

        customer_order_item.update!(
          cantidad: customer_order_item.cantidad + 2
        )

        # puts "after update: #{customer_order_item}"
        # puts "total: #{customer_order.reload.subtotal_items}"
      end

      it {
        subtotal_1 = older_order_item.cantidad * older_order_item.provider_item_precio
        subtotal_2 = customer_order_item.cantidad * customer_order_item.provider_item_precio

        expect(
          customer_order.subtotal_items
        ).to eq(subtotal_1 + subtotal_2)
      }
    end

    describe "upon removal" do
      let(:customer_order_item) {
        create :customer_order_item
      }
      let(:older_order_item) {
        create :customer_order_item,
               customer_order: customer_order
      }

      before do
        older_order_item

        customer_order_item.destroy
      end

      it {
        expect(
          customer_order.subtotal_items
        ).to eq(older_order_item.subtotal)
      }
    end
  end
end
