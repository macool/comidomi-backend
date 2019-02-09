module PaperTrail
  class Version < ::ActiveRecord::Base
    include PaperTrail::VersionConcern

    scope :latest, -> {
      unscope(:order).order(id: :desc)
    }
  end
end
