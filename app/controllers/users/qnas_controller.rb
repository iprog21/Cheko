class Users::QnasController < Users::UserAppController
  before_action :authenticate_user!
  
  def index
    @qna = current_user.qnas
  end

  def new
    @qna = current_user.qnas.new
  end

  def create
    @qna = current_user.qnas.create(qna_params)
    redirect_to users_path  # users_qna_path(@qna.id)
  end

  def show 
    @qna = Qna.find(params[:id])
  end

  private

  def qna_params
    params.require(:qna).permit(:question, :subject)
  end
end
