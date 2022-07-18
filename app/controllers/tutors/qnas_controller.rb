class Tutors::QnasController < ApplicationController
  before_action :authenticate_tutor!

  def index
    @pending = Qna.where(status: "pending")
    @assigned = Qna.where(tutor_id: current_tutor.id, status: "assigned")
  end

  def assign
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: current_tutor.id, status: "assigned")
    @qna.chats.create
    redirect_to tutors_qnas_path
  end

  def cancel
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: current_tutor.id, status: "assigned")
    
    redirect_to tutors_qnas_path
  end

  def show
  end
end
