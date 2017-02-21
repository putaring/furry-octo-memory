class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    mail(to: 'sanjayroozam@gmail.com', subject: 'Welcome to Roozam')
  end
end
