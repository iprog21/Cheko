class QnasController < ApplicationController
  # def index
  #   @qnas = Qna.where("status = 0 OR status = 1")
  #   @finish = Qna.where(status: "done")
  # end

  def new
    # qna_old = Qna.find_by(auth: cookies[:tutor_qna])
    # logger.info "\n\n\n #{cookies[:tutor_qna]}\n\n\n"
    qna_old = Qna.find_by(auth: cookies[:tutor_qna])
    if qna_old
      logger.info "\n\n\n #{qna_old.id}"
      redirect_to qna_path(qna_old.id)
    else
      @qna = Qna.new
    end
  end

  def create
    @qna = Qna.create(qna_params)
    cookies[:tutor_qna] = @qna.auth
    redirect_to root_path 
  end

  def show 
    @qna = Qna.find(params[:id])
    @message = Message.new
  end

  def finish
    @qna = Qna.find(params[:qna_id])
    @qna.update(status: "done", auth: "finish")
    redirect_to root_path
  end

  private

  def qna_params
    params.require(:qna).permit(:question, :subject, :document)
  end
end
