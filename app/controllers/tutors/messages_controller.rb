class Tutors::MessagesController < ApplicationController
  before_action :authenticate_tutor!
  
  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])

    if current_user.id == qna.user_id
      message = current_user.messages.create(content: params[:content], chat_id: chat.id)
      SendMessageJob.perform_now(message)
    end
  end
end
