class Tutors::QnasController < ApplicationController
  before_action :authenticate_tutor!

  def index
    @pending = Qna.where(status: "pending")
    @assigned = Qna.where(tutor_id: current_tutor.id, status: "assigned")
  end

  def assign
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: current_tutor.id, status: "assigned")
    Chat.create(qna_id: @qna.id)
    redirect_to tutors_qna_path(@qna)
  end

  def cancel
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: current_tutor.id, status: "pending")
    @qna.chat.destroy
    redirect_to tutors_qnas_path
  end

  def show
    @qna = Qna.find(params[:id])
    @message = Message.new
  end
end
