class DeletePhotoJob < ActiveJob::Base
  queue_as :low

  def perform(photo_id)
    Photo.deleted.find(photo_id).try(:destroy)
  end
end
