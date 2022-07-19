class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message, type)
    chat_id = message.chat_id
    ActionCable.server.broadcast("message_channel_#{chat_id}", html: message.content, type: type)
  end
end
