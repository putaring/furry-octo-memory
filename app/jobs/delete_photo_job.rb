class DeletePhotoJob < ActiveJob::Base
  queue_as :photo_deleter

  def perform(photo_id)
    Photo.deleted.find(photo_id).try(:destroy)
  end
end
