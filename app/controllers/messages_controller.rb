class MessagesController < ApplicationController
  before_action :authenticate!, :set_conversation, only: :create

  def create
    message = @conversation.messages.build(body: params[:message][:body], user_id: params[:user_id])
    if message.save
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
