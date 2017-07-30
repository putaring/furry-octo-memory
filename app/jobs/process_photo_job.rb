class ProcessPhotoJob < ActiveJob::Base
  queue_as :critical

  def perform(photo_id, attributes)
    photo_attributes  = attributes.except(:remote_image_url)
    image_url         = attributes[:remote_image_url]
    uri               = URI.parse(image_url)
    uri.open do |file|
      if file.class == StringIO
        tempfile  = file
        file      = Tempfile.new([SecureRandom.uuid, '.jpg'])

        file.binmode
        file.write tempfile.read
      end

      photo = Photo.inactive.find(photo_id)
      photo.process_remote_picture(photo_attributes.merge(image: file)) if photo.present?

      file.close
      file.unlink
    end
  end
end
