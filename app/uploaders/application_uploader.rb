# encoding: utf-8
class ApplicationUploader < CarrierWave::Uploader::Base
  if defined?(Cloudinary)
    include Cloudinary::CarrierWave
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
