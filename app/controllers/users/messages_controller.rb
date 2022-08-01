class Users::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])

    if current_user.id == qna.user_id
      message = current_user.messages.create(content: params[:message][:content], chat_id: chat.id, document: params[:message][:document])
      SendMessageJob.perform_now(message, "User", { document_url: message.document.attached? ? rails_blob_path(message.document, disposition: 'attachment') : nil })
    end
  end

  def destroy
  end
end
