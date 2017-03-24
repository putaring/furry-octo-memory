class ProcessPhotoJob < ActiveJob::Base
  queue_as :photos

  def perform(photo_id, attributes)
    photo = Photo.find(photo_id)
    photo.update_attributes(attributes.merge(status: Photo.statuses[:active]))
  end
end
