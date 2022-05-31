class Admins::HomeworksController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_homework, except: [:index]

  def index
    @homeworks = Homework.all
  end

  def show
    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
  end

  def destroy
    @homework.destroy!
    redirect_to admins_homeworks_path
  end

  def edit
    @leads = Admin.all
    @managers = Manager.all
    @tutors = Tutor.all
  end

  def update
    @homework.update(manager_id: params[:homework][:manager_id], tutor_id: params[:homework][:tutor_id])
    redirect_to admins_homeworks_path
  end

  def assign
    @homework.update(admin_id: current_admin.id)
    redirect_to admins_homeworks_path
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
