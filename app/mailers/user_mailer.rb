class UserMailer < ApplicationMailer
  default from: 'sanjayroozam@gmail.com'

  def welcome_email(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Welcome to Spouzz')
  end

  def password_email(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Reset your password')
  end

  def message_email(message_id)
    @message = Message.find(message_id)
    @sender  = @message.sender
    mail(to: @message.recipient.email, subject: "New message from #{@sender.username}")
  end

  def like_email(interest_id)
    like    = Interest.find(interest_id)
    @liker  = like.liker
    mail(to: like.liked.email, subject: "New interest from #{@liker.username}")
  end

  def decline_email(recipient_id, sender_id)
    recipient = User.find(recipient_id)
    @user     = User.find(sender_id)
    mail(to: recipient.email, subject: "#{@user.username} declined your interest")
  end

  def match_email(interest_id)
    like    = Interest.find(interest_id)
    @liker  = like.liker
    mail(to: like.liked.email, subject: 'You have a mutual like')
  end
end
