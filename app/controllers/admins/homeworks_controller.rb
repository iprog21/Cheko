class Admins::HomeworksController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_homework, except: [:index]

  def index
    @history = current_admin.role == "admin" ? Homework.where(status: "done", admin_id: current_admin.id).order(created_at: :asc) : Homework.where(status: "done").order(created_at: :asc)
    @pending = Homework.where(status: "reviewing", admin_id: current_admin.id)
    @ongoing = current_admin.role == "admin" ? Homework.where(status: "ongoing", admin_id: current_admin.id) : Homework.where(status: "ongoing")
    # @ongoing = Homework.find_by_sql("SELECT * FROM homeworks WHERE status IN(2,6) AND admin_id = #{current_admin.id}") 
    @finished_by_tutor = Homework.where(status: "finished_by_tutor", admin_id: current_admin.id)
  end

  def show
    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
    @admin = @homework.documents.where(documentable_type: "Admin")
  end

  def destroy
    @homework.destroy!
    redirect_to admins_homeworks_path, alert: "Homework successfully deleted"
  end

  def edit
    @leads = Admin.all
    @managers = Manager.all
    @tutors = Tutor.all
  end

  def update

    work = @homework.update(homework_params.to_h)
    
    if params[:homework][:internal_deadline].present?
      internal_deadline = DateTime.strptime(params[:homework][:internal_deadline], "%m/%d/%Y, %I:%M %p")
    else
      internal_deadline = DateTime.now - 1.day
    end
    @homework.update(internal_deadline: internal_deadline)

    if work && @homework.admin_id.present? && @homework.status == "reviewing"
      @homework.accept_order
    end

    if params[:homework][:tutor_price].present?
      @homework.assign_tutor(nil, params[:homework][:tutor_price].to_i)
    end

    redirect_to admins_homeworks_path, notice: "Homework successfully updated"
  end

  def assign
    if @homework.internal_deadline.blank?
      internal_deadline = DateTime.now - 1.day
    end
   
    @homework.update(admin_id: current_admin.id, internal_deadline: internal_deadline)
    @homework.accept_order
    redirect_to admins_homeworks_path #, notice: "Successfully assigned"
  end

  def assign_tutor
    bid = Bid.find(params[:bid_id])
    @homework.assign_tutor(bid)
    
    # if @homework.price.present? && @homework.tutor_price.present?
    #   @homework.calculate_profit
    # end
    name = "#{@homework.user.first_name[0,1].capitalize}#{@homework.user.last_name[0,1].capitalize}_#{@homework.subject}##{@homework.deadline.strftime("%b%m")}_#{@homework.tutor.first_name[0,1].capitalize}#{@homework.tutor.last_name[0,1].capitalize}"
    @homework.update(name: name)

    redirect_to admins_homeworks_path
  end

  def finish_homework
    @homework.finish_order
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Finish")
    redirect_to admins_homeworks_path
  end

  def upload
    @homework.documents.create(file: params[:document][:file], documentable_id: current_admin.id, documentable_type: current_admin.class.name)
    redirect_to admins_homeworks_path(@homework_id)
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end

  def homework_params
    if params[:homework][:deadline].present?
      deadline = DateTime.strptime(params[:homework][:deadline], "%m/%d/%Y, %I:%M %p")
      params.require(:homework).permit(:admin_id, :manager_id, :tutor_id, :sub_tutor_id, :price, :additional, :internal_subject, :subject, :internal_deadline, :details, :priority, :tutor_price, :view_bidders, :login_school, :tutor_samples, :tutor_skills, :name).merge(deadline: deadline)
    else
      params.require(:homework).permit(:admin_id, :manager_id, :tutor_id, :sub_tutor_id, :price, :additional, :internal_subject, :subject, :internal_deadline, :details, :priority, :tutor_price, :view_bidders, :login_school, :tutor_samples, :tutor_skills, :name)
    end
  end
end
