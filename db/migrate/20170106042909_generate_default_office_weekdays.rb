class GenerateDefaultOfficeWeekdays < ActiveRecord::Migration
  def up
    ProviderOffice.find_each do |provider_office|
      if provider_office.weekdays.empty?
        provider_office.build_weekdays
        provider_office.save(validate: false)
      end
    end
  end
end
