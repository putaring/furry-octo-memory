require 'googleauth'
require 'google/apis/analyticsreporting_v4'
#require 'openssl'
#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Analyticsreporting = Google::Apis::AnalyticsreportingV4
scopes = [Analyticsreporting::AUTH_ANALYTICS_READONLY]
service = Analyticsreporting::AnalyticsReportingService.new
service.authorization = Google::Auth.get_application_default(scopes)
service.batch_get_reports
