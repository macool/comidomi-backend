class ImageVersionableUploader < ApplicationUploader
  unless defined?(Cloudinary)
    include CarrierWave::MiniMagick
  end

  version :big do
    process resize_to_limit: [1000, 1000]
  end

  version :small do
    process resize_to_limit: [500, 500]
  end

  version :thumbnail do
    process resize_to_limit: [300, 300]
  end

  version :small_padded do
    process resize_and_pad: [500, 500]
  end

  version :small_cropped do
    process resize_to_fill: [500, 500]
  end

  version :thumbnail_cropped do
    process resize_to_fill: [320, 200]
  end

  protected

  def extension_white_list
    %w(jpg jpeg png)
  end

  def content_type_whitelist
    /image\//
  end
end
