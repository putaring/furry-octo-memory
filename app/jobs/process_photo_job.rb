class ProcessPhotoJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) { |e| Shoryuken.logger.error e }

  def perform(photo_id, attributes)
    photo             = Photo.inactive.find(photo_id)
    photo.attributes  = attributes.merge(status: Photo.statuses[:active])
    photo.save
  end

end
