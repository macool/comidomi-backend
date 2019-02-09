if @api_resource.errors.present?
  json.errors do
    @api_resource.errors.to_hash.each do |key, value|

      # do not include duplicate errors
      if value.is_a?(Array)
        value = value.uniq
      end

      json.set! key, value
    end
  end
end
