# == Schema Information
#
# Table name: shipping_requests
#
#  id                  :integer          not null, primary key
#  resource_id         :integer          not null
#  resource_type       :string           not null
#  kind                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  status              :string           default("new"), not null
#  address_attributes  :json
#  courier_profile_id  :integer
#  reason              :string
#  place_id            :integer          not null
#  waypoints           :json
#  estimated_time_mins :integer
#  assigned_at         :datetime
#  ref_lat             :float            not null
#  ref_lon             :float            not null
#

class ShippingRequest < ActiveRecord::Base
  extend Enumerize

  STATUSES = [
    :new,
    :assigned, # courier is set
    :confirmed, # preparation time is provided
    :in_progress, # on the way to customer's address
    :delivered, # delivered to customer
    :canceled
  ].freeze
  KINDS = [
    :ask_to_validate,
    :customer_errand,
    :customer_order_delivery
  ].freeze

  has_paper_trail

  acts_as_mappable(
    lat_column_name: :ref_lat,
    lng_column_name: :ref_lon
  )

  begin :callbacks
    before_validation :set_ref_coordinates
  end

  begin :relationships
    belongs_to :place
    belongs_to :courier_profile
    belongs_to :resource, polymorphic: true
  end

  begin :enumerables
    enumerize :kind,
              in: KINDS,
              scope: true,
              i18n_scope: "shipping_request.kinds"
    enumerize :status,
              in: STATUSES,
              scope: true,
              i18n_scope: "shipping_request.statuses"
  end

  begin :validations
    ##
    # resource may be the provider we need to validate
    # resource may be what we're delivering (customer_order_delivery)
    validates :resource,
              :kind,
              :status,
              :place_id,
              :ref_lat,
              :ref_lon,
              presence: true
  end

  begin :scopes
    scope :latest, ->{
      order(created_at: :desc)
    }
    scope :for_place, ->(place){
      where(place_id: place.id)
    }
    scope :for_courier, ->(courier_profile){
      where(courier_profile_id: courier_profile.id)
    }
  end

  def estimated_delivery_at
    if assigned_at.present? && estimated_time_mins.present?
      # TODO
      # consider provider's preparation time
      assigned_at + estimated_time_mins.minutes
    end
  end

  def estimated_dispatch_at
    case kind
    when "ask_to_validate"
      created_at
    when "customer_order_delivery"
      resource.dispatch_at
    end
  end

  private

  def set_ref_coordinates
    return if address_attributes.blank?
    self.ref_lat = address_attributes["lat"] if ref_lat.blank?
    self.ref_lon = address_attributes["lon"] if ref_lon.blank?
  end
end
