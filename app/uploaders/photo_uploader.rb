# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :orient
  process :set_original_width

  process convert: 'jpg'
  process resize_to_limit: [1500, 1500]

  process :set_final_width
  process :set_final_crop_origin

  version :thumb do
    process :crop
    process resize_to_fill: [400,400]
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [120, 120]
  end

  def orient
    manipulate! do |img|
      img.auto_orient
    end
  end

  def crop
    if model.image_x.present? && model.image_width.present?
      manipulate! do |img|
        img.crop("#{final_crop_width}x#{final_crop_width}+#{model.final_crop_x}+#{model.final_crop_y}")
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
    "#{secure_token}.jpg" if original_filename
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def set_original_width
    model.original_image_width = ::MiniMagick::Image.open(file.file)[:dimensions][0]
  end

  def set_final_width
    model.final_image_width = ::MiniMagick::Image.open(file.file)[:dimensions][0]
  end

  def final_scale
    @_final_scale ||= (model.final_image_width.to_f / model.original_image_width.to_f)
  end

  def final_crop_width
    @_final_crop_width ||= (model.image_width.to_f * final_scale)
  end

  def set_final_crop_origin
    model.final_crop_x  = model.image_x.to_f * final_scale
    model.final_crop_y  = model.image_y.to_f * final_scale
  end

end
