class DeleteJob < ActiveJob::Base
  queue_as 'normal'
  def perform(data)
    Shrine::Attacher.delete(data)
  end
end
