class Tutors::MessagesController < ApplicationController
  before_action :authenticate_tutor!
  
  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])

    if current_tutor.id == qna.tutor_id
      message = current_tutor.messages.create(content: params[:content], chat_id: chat.id)
      SendMessageJob.perform_now(message, "Tutor")
    end
  end

  private

  def msg_params
    params.require(:message).permit(:content, :document)
  end
end
