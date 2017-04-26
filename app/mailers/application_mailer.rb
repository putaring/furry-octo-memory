class ApplicationMailer < ActionMailer::Base
  helper EmailHelper
  layout 'mailer'
end
