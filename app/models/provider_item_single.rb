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
#  type                      :string           default("ProviderItemSingle"), not null
#

class ProviderItemSingle < ProviderItem
  
end
