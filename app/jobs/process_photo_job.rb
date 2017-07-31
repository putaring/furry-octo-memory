class ProcessPhotoJob < ActiveJob::Base
  queue_as :critical

  def perform(photo_id, attributes)
    photo             = Photo.inactive.find(photo_id)
    photo.attributes  = attributes.merge(status: Photo.statuses[:active])
    photo.save
  end
end
