class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    mail(to: user.email, subject: 'Welcome to Roozam')
  end
end
