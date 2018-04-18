class DeleteJob < ActiveJob::Base
  queue_as 'low'
  def perform(data)
    Shrine::Attacher.delete(data)
  end
end
