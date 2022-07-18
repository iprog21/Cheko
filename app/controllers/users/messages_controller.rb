class Users::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])

    if current_user.id == qna.user_id
      message = chat.messages.create(content: params[:content], sendable_id: current_user.id, sendable_type: "User")
      SendMessageJob.perform_now(message)
    end
  end

  def destroy
  end
end
