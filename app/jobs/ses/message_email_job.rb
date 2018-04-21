module Ses
  class MessageEmailJob < Ses::BaseJob
    def perform(message_id)
      self.message = Message.find_by(id: message_id)
      if message.present?
        self.recipient    = message.recipient
        self.sender       = message.sender
        self.conversation = message.conversation
        super() if recipient && sender && conversation
      end
    end

    private

    attr_accessor :message, :conversation, :sender

    def template
      'Message'
    end

    def template_data
      {
        sender:             sender.username,
        sender_avatar_url:  ApplicationController.helpers.liker_avatar_url(sender),
        conversation_url:   conversation_url(conversation),
        message:            message.body
      }
    end
  end
end
