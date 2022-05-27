class Admins::HomeworksController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_homework, except: [:index]

  def index
    @homeworks = Homework.all
  end

  def show
  end

  def destroy
    @homework.destroy!
    redirect_to admins_homeworks_path
  end

  def edit
    @leads = Manager.all
  end

  def update
    @homework.update(manager_id: params[:homework][:manager_id])
    redirect_to admins_homeworks_path
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id])
  end
end
