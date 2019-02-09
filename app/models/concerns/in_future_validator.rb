class InFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && value < Time.zone.now
      record.errors.add(attribute, :must_be_future)
    end
  end
end
