class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to Roozam')
  end

  def password_email(user)
    @user = user
    mail(to: user.email, subject: 'Reset your password')
  end
end
