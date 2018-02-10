class DeleteJob < ActiveJob::Base
  queue_as 'default.fifo'
  def perform(data)
    Shrine::Attacher.delete(data)
  end
end
