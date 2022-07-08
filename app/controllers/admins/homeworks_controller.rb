class Admins::HomeworksController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_homework, except: [:index]

  def index
    @history = current_admin.role == "admin" ? Homework.where(status: "done", admin_id: current_admin.id).order(created_at: :asc) : Homework.where(status: "done").order(created_at: :asc)
    @pending = Homework.where(status: "reviewing") 
    @ongoing = current_admin.role == "admin" ? Homework.where(status: "ongoing", admin_id: current_admin.id) : Homework.where(status: "ongoing")
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
    # if current_admin.role == "super_admin"
    #   work = @homework.update(homework_params)
    # else
    #   work = @homework.update(homework_params)
    # end
    work = @homework.update(homework_params)

    if work && @homework.admin_id.present? && @homework.status == "reviewing"
      @homework.accept_order
    end

    @homework.assign_tutor(nil, params[:homework][:tutor_price].to_i)
    
    # if @homework.price.present? && @homework.tutor_price.present?
    #   @homework.calculate_profit
    # end

    redirect_to admins_homeworks_path
  end

  def assign
    @homework.update(admin_id: current_admin.id)
    @homework.accept_order
    redirect_to admins_homeworks_path
  end

  def assign_tutor
    bid = Bid.find(params[:bid_id])
    @homework.assign_tutor(bid)
    
    if @homework.price.present? && @homework.tutor_price.present?
      @homework.calculate_profit
    end
    
    redirect_to admins_homeworks_path
  end

  def finish_homework
    @homework.finish_order
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Finish")
    redirect_to admins_homeworks_path
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end

  def homework_params
    params.require(:homework).permit(:admin_id, :manager_id, :tutor_id, :price, :additional, :internal_deadline)
  end
end
