class MessagesController < ApplicationController
  before_action :set_conversation, only: :create
  before_action :authenticate!

  def index
    @messages = current_user.received_messages.joins(:sender).includes(:sender).reverse_order.to_a.uniq { |m| m.conversation_id }
  end

  def sent
    @messages = current_user.sent_messages.includes(:recipient).reverse_order.to_a.uniq { |m| m.conversation_id }
  end

  def create
    message = @conversation.messages.build(body: params[:message][:body], sender_id: current_user.id,
      recipient_id: @conversation.other_participant(current_user).id, ip: request.remote_ip)
    if message.save
      UserMailer.message_email(message).deliver_later
      if request.xhr?
        render json: message, status: :created
      else
        redirect_to user_path(params[:user_id])
      end
    else
      if request.xhr?
        render json: message.errors.full_messages, status: :unprocessable_entity
      else
        redirect_to user_path(params[:user_id])
      end
    end
  end

  private

  def set_conversation
    @conversation = Conversation.between(current_user.id, params[:user_id]) ||
      Conversation.create!(sender_id: current_user.id, recipient_id: params[:user_id])
  end

end
