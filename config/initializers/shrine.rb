require 'shrine'
require 'image_processing/mini_magick'
require 'shrine/storage/s3'

Shrine.plugin :backgrounding
Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type
Shrine.plugin :presign_endpoint, presign_options: -> (request) do
  {
    content_length_range: 0..(5*1024*1024),
    content_type:        Rack::Mime.mime_type(File.extname(request.params["filename"]))
  }
end

Shrine.plugin :cached_attachment_data
Shrine.plugin :default_url_options, store: { host: ENV.fetch('CDN_HOST'), public: true }

Shrine::Attacher.promote { |data| PromoteJob.perform_later(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_later(data) }

upload_options = { cache_control: 'public, max-age=31536000' }

s3_options = {
  access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  region:            ENV.fetch('AWS_REGION'),
  bucket:            ENV.fetch('S3_BUCKET')
}

Shrine.storages = {
    cache: Shrine::Storage::S3.new(upload_options: upload_options, prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(upload_options: upload_options, prefix: 'store', **s3_options)
}
