class ApplicationController < ActionController::Base
  module PaperTrailable
    extend ActiveSupport::Concern

    included do
      before_action :set_paper_trail_whodunnit
    end
  end
end
