# encoding: utf-8

class AvatarUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions
  plugin :delete_raw, storages: [:store]
  plugin :store_dimensions
  plugin :pretty_location

  process(:store) do |io, context|
    crop_info       = JSON.parse(context[:record].image_data, object_class: OpenStruct).cropInfo
    raw             = convert!(io.download, 'jpg') { |cmd| cmd.auto_orient }
    cropped_image   = crop(raw, crop_info.width, crop_info.width, crop_info.x, crop_info.y)
    large           = resize_to_fill(cropped_image, 400, 400)
    small           = resize_to_fill(cropped_image, 200, 200)

    { large: large, small: small }
  end
end
