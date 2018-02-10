# encoding: utf-8

class PhotoUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions
  plugin :delete_raw
  plugin :hooks
  plugin :determine_mime_type

  process(:store) do |io, context|
    crop_dimensions = JSON.parse(context[:record].image_data, object_class: OpenStruct).cropDimensions
    raw             = convert!(io.download, "jpg") { |cmd| cmd.auto_orient }
    cropped_image   = crop(raw, crop_dimensions.width, crop_dimensions.width, crop_dimensions.offsetX, crop_dimensions.offsetY)
    large           = resize_to_limit(cropped_image, 1500, 1500)
    thumb           = resize_to_fill(cropped_image, 400, 400)

    { large: large, thumb: thumb }
  end

  def after_upload(io, context)
    super
    context[:record].active!
  end
end
