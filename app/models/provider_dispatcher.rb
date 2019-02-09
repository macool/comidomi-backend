# == Schema Information
#
# Table name: provider_dispatchers
#
#  id                 :integer          not null, primary key
#  provider_office_id :integer          not null
#  email              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#

class ProviderDispatcher < ActiveRecord::Base
  include SoftDestroyable

  validates :email, presence: true
  validates :provider_office_id, presence: true

  begin :relationships
    belongs_to :provider_office
  end

  def user
    @user ||= User.find_by(email: email)
  end
end
