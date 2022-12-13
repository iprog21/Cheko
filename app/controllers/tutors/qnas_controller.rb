class Tutors::QnasController < ApplicationController
  before_action :authenticate_tutor!

  def index
    @pending = Qna.where(status: "pending")
    @assigned = Qna.where(tutor_id: current_tutor.id, status: "assigned")
  end

  def assign
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: current_tutor.id, status: "assigned")
    # Chat.create(qna_id: @qna.id)

    message = Message.create(content: "A Tutor has accepted your question, please refresh the page to start chatting", chat_id: @qna.chat.id)
    SendMessageJob.perform_now(message, "Accept", message.chat_id)

    if @qna.user.present?
      QnaMailer.with(qna: @qna).notify_user.deliver_now
    end

    redirect_to tutors_qna_path(@qna)
  end

  def cancel
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: nil, status: "pending")
    message = current_tutor.messages.create(content: "Tutor has cancelled, please refresh the page to wait for a new Tutor", chat_id: @qna.chat.id)
    SendMessageJob.perform_now(message, "Cancel", message.chat_id)
    redirect_to tutors_qnas_path
  end

  def show
    @qna = Qna.find(params[:id])
    @message = Message.new
  end

  def add_payment
    date_paid = DateTime.strptime(params[:qna][:date_paid], "%m/%d/%Y, %I:%M %p")
    @qna = Qna.find(params[:qna_id])
    @qna.update(amount: params[:qna][:amount], date_paid: date_paid, payment_receipt: params[:qna][:payment_receipt], payment_status: 1)
    redirect_to tutors_qna_path(params[:qna_id])
  end

end
