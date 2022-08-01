class Tutors::MessagesController < ApplicationController
  before_action :authenticate_tutor!
  
  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])

    if current_tutor.id == qna.tutor_id
      message = current_tutor.messages.create(content: params[:message][:content], chat_id: chat.id, document: params[:message][:document])
      SendMessageJob.perform_now(message, "Tutor", { document_url: message.document.attached? ? rails_blob_path(message.document, disposition: 'attachment') : nil })
    end
  end

  private

  def msg_params
    params.require(:message).permit(:content, :document)
  end
end
