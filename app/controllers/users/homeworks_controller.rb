class Users::HomeworksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_homework, except: [:index, :create, :new, :pick_type]
  
  def index
    @homeworks = current_user.homeworks
  end

  def show
  end

  def pick_type
  end

  def new
    @homework = current_user.homeworks.new
  end

  def create
    @homework = current_user.homeworks.new(homework_params)
    if @homework.save
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
    params.require(:homework).permit(:details, :payment_type, :deadline, :subject, :sub_subject, :budget, :tutor_skills, :tutor_samples, :sub_type, :priority, :view_bidders, :login_school, :budget, :order_type, :words, :tutor_category)
  end
end
