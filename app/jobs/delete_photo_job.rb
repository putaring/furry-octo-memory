class DeletePhotoJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) { |e| Shoryuken.logger.error e }
  def perform(photo_id)
    Photo.deleted.find(photo_id).try(:destroy)
  end
end
