class LogProfileVisitsJob < ActiveJob::Base
  queue_as :default

  def perform(visit_details)
    ProfileVisit.where(visitor_id: visit_details[:visitor_id], visited_id: visit_details[:visited_id],
      date: visit_details[:date]).first_or_create!(visits: visit_details[:visits])
  end
end
