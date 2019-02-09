module SoftDestroyable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }
  end

  ##
  # performs a soft-delete
  def soft_destroy
    update_attribute(:deleted_at, Time.now)
  end
end
