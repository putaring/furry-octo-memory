require 'googleauth'
require 'google/apis/analyticsreporting_v4'
unless Rails.env.production?
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end
#TODO
# Need to add custom dimension for profile ID because pagepath includes query string

class VisitorReportingService
  Analyticsreporting      = Google::Apis::AnalyticsreportingV4

  def initialize;end

  def log_visitor_count_on(date)
    service               = Analyticsreporting::AnalyticsReportingService.new
    service.authorization = Google::Auth.get_application_default(Analyticsreporting::AUTH_ANALYTICS_READONLY)

    date_ranges = [
      {
        start_date: date,
        end_date: date
      }
    ]
    request = visitor_report_request.merge(date_ranges: date_ranges)

    next_page_token = nil
    loop do
      response = service.batch_get_reports(Analyticsreporting::GetReportsRequest.new({report_requests: [request.merge(page_token: next_page_token)]}))
      report  = response.reports.first
      rows    = report.data.rows || []
      rows.each do |row|
        #LogProfileVisitsJob.perform_later(
        x = {
          visited_id: row.dimensions.first.to_s,
          visitor_id: row.dimensions.second,
          visits: row.metrics.first.values.first,
          date: date
        }
        puts x
        #)
      end
      next_page_token = report.next_page_token
      break if next_page_token.blank?
    end
  end

  private

  def visitor_report_request
    {
     view_id: ENV["GA_VIEW_ID"],
     dimensions: [
      {
       name: "ga:pagePath"
      },
      {
       name: "ga:dimension1"
      }
     ],
     metrics: [
      {
       expression: "ga:pageViews"
      }
     ],
     dimension_filter_clauses: [
      {
       filters: [
        {
         dimension_name: "ga:pagePath",
         expressions: [
          "^\\/users\\/\\d"
         ]
        }
       ]
      }
    ]
    }
  end
end
