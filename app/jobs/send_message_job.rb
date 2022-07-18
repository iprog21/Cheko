class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    html = "<p>#{message.content}</p>"
    chat_id = message.chat_id
    ActionCable.server.broadcast("message_channel_#{chat_id}", html: html)
  end
end
