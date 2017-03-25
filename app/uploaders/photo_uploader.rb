# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process convert: 'jpg'

  # Create different versions of your uploaded files:

  version :large do
    process resize_to_limit: [1500, 1500]
  end

  version :thumb do
    process :crop
    process resize_to_fill: [400,400]
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [120, 120]
  end

  def crop
    if model.image_x.present? && model.image_width.present?
      manipulate! do |img|
        img.crop("#{model.image_width}x#{model.image_width}+#{model.image_x}+#{model.image_y}")
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{file.basename}.jpg" if original_filename
  end

end
