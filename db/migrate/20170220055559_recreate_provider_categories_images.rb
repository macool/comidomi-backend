class RecreateProviderCategoriesImages < ActiveRecord::Migration
  def up
    say_with_time "recreating provider categories' images versions" do
      ProviderCategory.find_each do |provider_category|
        provider_category.imagen.recreate_versions! if provider_category.imagen.file.present?
      end
    end
  end

  def down
    say "doing nothing about it.."
  end
end
