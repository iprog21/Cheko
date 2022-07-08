class Users::HomeworksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_homework, except: [:index, :create, :new, :pick_type]
  
  def index
    # @pending = current_user.homeworks.where(status: "reviewing")
    # @ongoing = current_user.homeworks.where(status: "ongoing")
    # @history = current_user.homeworks.where(status: "done")
    @homeworks = current_user.homeworks
  end

  def show
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
  end

  def pick_type
  end

  def new
    @homework = current_user.homeworks.new
  end

  def create
    @homework = current_user.homeworks.new(homework_params)
    if @homework.save
      # HomeworkMailer.with(homework: @homework).notify_admin.deliver_now
      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Admin")
      redirect_to users_homeworks_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @homework.update!(homework_params)
      redirect_to users_homeworks_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id])
  end

  def homework_params
    params.require(:homeworks).permit(:details, :payment_type, :deadline, :subject, :sub_subject, :budget, :tutor_skills, :tutor_samples, :sub_type, :priority, :view_bidders, :login_school, :budget, :order_type, :words, :tutor_category)
  end
end
