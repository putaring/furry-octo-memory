if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
    config.storage = :file
  end
else Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
      region:                 ENV['AWS_REGION']
    }
    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_attributes = {'Cache-Control' => "public, max-age=#{365.day.to_i}"}
    config.asset_host     = ENV['CDN_HOST']
    config.storage        = :fog
    config.cache_dir      = "#{Rails.root}/tmp/uploads"
  end
end
