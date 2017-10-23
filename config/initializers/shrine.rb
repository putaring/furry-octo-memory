require 'shrine'
require 'image_processing/mini_magick'
require 'shrine/storage/s3'

Shrine.plugin :backgrounding
Shrine.plugin :activerecord
Shrine.plugin :presign_endpoint
Shrine.plugin :logging, format: :heroku
Shrine.plugin :cached_attachment_data
Shrine.plugin :logging
Shrine.plugin :default_url_options, store: { host: ENV['CDN_HOST'], public: true }
Shrine.plugin :pretty_location

Shrine::Attacher.promote { |data| PromoteJob.perform_later(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_later(data) }

upload_options = { cache_control: 'public, max-age=31536000' }

s3_options = {
  access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region:            ENV['AWS_REGION'],
  bucket:            ENV['S3_BUCKET'],
}

Shrine.storages = {
    cache: Shrine::Storage::S3.new(upload_options: upload_options, prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(upload_options: upload_options, prefix: 'store', **s3_options)
}
