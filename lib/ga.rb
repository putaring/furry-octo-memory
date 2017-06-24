require 'googleauth'
require 'google/apis/analyticsreporting_v4'
#require 'openssl'
#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Analyticsreporting = Google::Apis::AnalyticsreportingV4
service = Analyticsreporting::AnalyticsReportingService.new
service.authorization = Google::Auth.get_application_default(Analyticsreporting::AUTH_ANALYTICS_READONLY)
service.batch_get_reports
