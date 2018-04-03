# encoding: utf-8

class PhotoUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions
  plugin :delete_raw
  plugin :store_dimensions
  plugin :pretty_location

  process(:store) do |io, context|
    raw             = convert!(io.download, 'jpg') { |cmd| cmd.auto_orient }
    large           = resize_to_limit(raw, 1600, 1600)
    thumb           = resize_to_limit(raw, 200, 200)

    { large: large, small: thumb }
  end
end
