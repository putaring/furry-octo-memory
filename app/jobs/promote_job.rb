class PromoteJob < ActiveJob::Base
  queue_as 'important'
  def perform(data)
    Shrine::Attacher.promote(data)
  end
end
