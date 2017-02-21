
class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ENV['MAIL_INTERCEPT_ADDRESSES']
  end
end

ActionMailer::Base.register_interceptor(SandboxEmailInterceptor) if ENV['MAIL_INTERCEPT_ADDRESS'].present?
