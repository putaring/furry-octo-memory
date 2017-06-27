=begin
r.reports[0].data.rows.first.metrics.first
=end


request = {
 view_id: "143379915",
 date_ranges: [
  {
   start_date: "2017-06-22",
   end_date: "2017-06-22"
  }
 ],
 dimensions: [
  {
   name: "ga:pagePathLevel2"
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
],
page_size: 1
}

require 'googleauth'
require 'google/apis/analyticsreporting_v4'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Analyticsreporting = Google::Apis::AnalyticsreportingV4
service = Analyticsreporting::AnalyticsReportingService.new
service.authorization = Google::Auth.get_application_default(Analyticsreporting::AUTH_ANALYTICS_READONLY)

next_page_token = nil
begin
  service.batch_get_reports(Google::Apis::AnalyticsreportingV4::GetReportsRequest.new({report_requests: [request.merge(page_token: next_page_token)]}))
  report = response.reports.first
  report.data.rows.each do |row|
    obj = {
      profile_id: row.dimensions.first[1..-1],
      visitor_id: row.dimensions.second,
      views: row.metrics.first.values.first
    }
    puts obj
  end
  next_page_token = report.next_page_token
end while next_page_token
