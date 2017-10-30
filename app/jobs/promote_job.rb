class PromoteJob < ActiveJob::Base
  queue_as 'default.fifo'
  def perform(data)
    Shrine::Attacher.promote(data)
  end
end
