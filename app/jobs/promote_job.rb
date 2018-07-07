class PromoteJob < ActiveJob::Base
  queue_as 'normal'
  def perform(data)
    Shrine::Attacher.promote(data)
  end
end
