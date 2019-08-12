namespace :provider_items do
  desc "migrate to provider items with Type set"
  task migrate_groups_to_types: :environment do
    ProviderItem.where(is_group: true).find_each do |provider_item|
      provider_item.type = "ProviderItemGroup"
      provider_item.save!
    end
  end
end
