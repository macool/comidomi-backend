require "porttare_backend/create_default_image_versions"

class CreateDefaultImageVersions < ActiveRecord::Migration
  def up
    say_with_time "creating default image versions" do
      PorttareBackend::CreateDefaultImageVersions.run!
    end
  end

  def down
    say "doing nothing"
  end
end
