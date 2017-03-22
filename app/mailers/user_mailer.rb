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

  def message_email(message)
    @message = message
    @sender  = @message.sender
    mail(to: @message.recipient.email, subject: "New message from #{@sender.username}")
  end

  def like_email(like)
    @liker = like.liker
    mail(to: like.liked.email, subject: "Somebody likes you")
  end

  def decline_email(recipient)
    @user = current_user
    mail(to: recipient.email, subject: "#{@user.username} declined your interest")
  end

  def match_email(like)
    @liker = like.liker
    mail(to: like.liked.email, subject: 'You have a match!')
  end
end
