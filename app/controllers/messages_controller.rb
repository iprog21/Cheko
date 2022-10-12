class MessagesController < ApplicationController
  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])


    if user_signed_in? || cookies[:tutor_qna] == qna.auth 
      message = Message.create(content: params[:message][:content], chat_id: chat.id, document: params[:message][:document], sendable_type: "User")
      SendMessageJob.perform_now(message, "User", { document_url: message.document.attached? ? rails_blob_path(message.document, disposition: 'attachment') : nil })
    end
  end

  def destroy
  end
end
