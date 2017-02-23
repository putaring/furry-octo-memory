CarrierWave.configure { |config| config.enable_processing = false } if Rails.env.test?

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['AWS_ID'],
      aws_secret_access_key:  ENV['AWS_SECRET'],
      region:                 ENV['S3_REGION']
    }
    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_attributes = {'Cache-Control' => 'public, max-age=31536000'}
    config.cache_dir      = "#{Rails.root}/tmp/uploads"
  end
else
  CarrierWave.configure { |config| config.storage = :file }
end
