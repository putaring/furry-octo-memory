# encoding: utf-8

class PhotoUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions
  plugin :delete_raw
  plugin :store_dimensions

  def generate_location(io, context)
    type = context[:record].class.name.underscore
    name = context[:name]

    dirname, slash, basename = super.rpartition("/")
    basename = "#{context[:version]}-#{basename}" if context[:version]
    original = dirname + slash + basename

    [type, SecureRandom.uuid, name, original].compact.join("/")
  end

  process(:store) do |io, context|
    raw             = convert!(io.download, 'jpg') { |cmd| cmd.auto_orient }
    large           = resize_to_limit(raw, 1600, 1600)
    thumb           = resize_to_limit(raw, 200, 200)

    { large: large, thumb: thumb }
  end
end
