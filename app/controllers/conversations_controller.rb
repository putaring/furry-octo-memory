class ConversationsController < ApplicationController
  before_action :authenticate!, :set_conversation

  def show
    @messages = @conversation.messages.order(:id)
  end

  private
  def set_conversation
    @conversation ||= Conversation.includes(:messages).with_participant(current_user).find(params[:id])
  end
end
