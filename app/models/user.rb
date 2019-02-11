# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  info                   :json
#  credentials            :json
#  tokens                 :json
#  created_at             :datetime
#  updated_at             :datetime
#  fecha_nacimiento       :date
#  ciudad                 :string
#  privileges             :text             default([]), is an Array
#  custom_image           :string
#  agreed_tos             :boolean          default(FALSE)
#  current_place_id       :integer
#

class User < ActiveRecord::Base
  PRIVILEGES = [
    :admin,
    :customer_service
  ].freeze

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :validatable, :omniauthable, omniauth_providers: [:facebook]

  extend Enumerize
  include DeviseTokenAuth::Concerns::User # after devise
  include FacebookImageCacheable

  has_paper_trail skip: [:tokens, :encrypted_password]

  begin :validations
    validates :email,
              presence: true,
              uniqueness: true,
              if: "provider == 'email'"
  end

  begin :relationships
    has_one :provider_profile
    has_one :courier_profile
    has_one :customer_profile
    has_many :user_devices
    has_many :locations,
             class_name: "UserLocation"
    belongs_to :current_place,
               class_name: "Place"
  end

  begin :scopes
    scope :by_name, -> { order(:name) }

    ##
    # define a scope for each privilege
    PRIVILEGES.each do |privilege|
      scope privilege, -> {
        where.overlap(privileges: [ privilege ])
      }
    end
  end

  enumerize :privileges,
            in: PRIVILEGES,
            multiple: true

  mount_uploader :custom_image, UserCustomImageUploader

  private

  ##
  # override devise's default
  # https://github.com/plataformatec/devise/blob/a9bb7d0318054ebb74d09d835927fbb377afd8bd/README.md#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
