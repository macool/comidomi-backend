class OwnAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && value.customer_profile != record.customer_profile
      record.errors.add("#{attribute}_id", :invalid)
    end
  end
end
