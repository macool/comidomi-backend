# == Schema Information
#
# Table name: provider_items
#
#  id                        :integer          not null, primary key
#  provider_profile_id       :integer
#  titulo                    :string           not null
#  descripcion               :text
#  unidad_medida             :integer
#  precio_cents              :integer          default(0), not null
#  precio_currency           :string           default("USD"), not null
#  volumen                   :string
#  peso                      :string
#  observaciones             :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  deleted_at                :datetime
#  cantidad                  :integer          default(0)
#  en_stock                  :boolean
#  provider_item_category_id :integer
#  parent_provider_item_id   :integer
#  is_group                  :boolean          default(FALSE)
#  type                      :string           default("ProviderItemSingle"), not null
#

require 'rails_helper'

RSpec.describe ProviderItem,
               type: :model do
  describe "factory" do
    subject { build :provider_item }
    it { is_expected.to be_valid }
  end

  describe "validates unidades de medida" do
    describe "invalid" do
      subject { build :provider_item }
      it {
        expect {
          subject.unidad_medida = "invalid"
        }.to raise_error(ArgumentError)
      }
    end
  end
end
