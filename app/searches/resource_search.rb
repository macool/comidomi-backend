class ResourceSearch < Searchlight::Search
  def searching?
    options.present?
  end
end
