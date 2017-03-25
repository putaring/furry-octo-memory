class ProcessPhotoJob < ActiveJob::Base
  queue_as :photos

  def perform(photo_id, attributes)
    photo = Photo.inactive.find(photo_id)
    photo.process_remote_picture(attributes) if photo.present?
  end
end
