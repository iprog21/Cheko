class SendMessageJob < ApplicationJob
  queue_as :default
  include Rails.application.routes.url_helpers
  def perform(message, type, opt={})
    chat_id = message.chat_id
    document = message.document.attached? ? opt[:document_url] : nil
    
    ActionCable.server.broadcast("message_channel_#{chat_id}", html: message.content, type: type, document: document) 
  end
end
