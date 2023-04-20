class Managers::HomeworksController < ApplicationController
  before_action :authenticate_manager!, except: [:upload]
  before_action :find_homework, except: [:index]
  
  def index
    # @homeworks = Homework.where(manager_id: current_manager.id).not_deleted
      @homeworks = Homework.where(status: "done").not_deleted
      @pending = Homework.where(status: "reviewing").order(created_at: :asc)
      @ongoing = Homework.where(status: "ongoing").order(created_at: :asc)
      @finished_by_tutor = Homework.where(status: "finished_by_tutor").order(created_at: :asc)

  end

  def show
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
    @manager = @homework.documents.where(documentable_type: "Manager")

    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
  end

  def edit
    @tutors = Tutor.all
    @homework = Homework.find(params[:id])
  end

  def update
    @homework = Homework.find(params[:id])
    homework = @homework.update(homework_params.to_h)

    if params[:homework][:internal_deadline].present?
      internal_deadline = DateTime.strptime(params[:homework][:internal_deadline], "%m/%d/%Y, %I:%M %p")
    else
      internal_deadline = DateTime.now - 1.day
    end
    @homework.update(internal_deadline: internal_deadline, manager_id: current_manager.id)

    if homework && @homework.admin_id.present? && @homework.status == "reviewing" 
      @homework.accept_order
    end

    if @homework.tutor_id.present?
      name = "#{@homework.user.first_name[0,1].capitalize}#{@homework.user.last_name[0,1].capitalize}_#{@homework.subject}##{@homework.deadline.strftime("%b%m")}_#{@homework.tutor.first_name[0,1].capitalize}#{@homework.tutor.last_name[0,1].capitalize}"
      @homework.update(name: name)

      tutor = Tutor.find(@homework.tutor_id)
      NotifyTutorJob.set(wait: 2.seconds).perform_later("approved_bid", tutor, @homework)
    end

    redirect_to managers_homeworks_path, alert: "Homework successfully updated"
  end

  def upload
    @homework.documents.create(file: params[:document][:file], documentable_id: current_manager.id, documentable_type: current_manager.class.name)
    # HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Finish")

    redirect_to managers_homework_path(@homework.id)
  end

  def approve
    @homework.finish_order
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "ApprovedByManager")

    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Finish")
    redirect_to managers_homework_path(@homework.id)
  end

  def assign_tutor
    bid = Bid.find(params[:bid_id])
    @homework.assign_tutor(bid)

    name = "#{@homework.user.first_name[0,1].capitalize}#{@homework.user.last_name[0,1].capitalize}_#{@homework.subject}##{@homework.deadline.strftime("%b%m")}_#{@homework.tutor.first_name[0,1].capitalize}#{@homework.tutor.last_name[0,1].capitalize}"

    @homework.update(name: name)

    tutor = Tutor.find(bid.tutor_id)
    NotifyTutorJob.set(wait: 2.seconds).perform_later("approved_bid", tutor, @homework)

    redirect_to managers_homework_path(@homework.id)
  end

  private
  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id]) 
  end

  def homework_params
    if params[:homework][:deadline].present?
      deadline = DateTime.strptime(params[:homework][:deadline], "%m/%d/%Y, %I:%M %p")
      params.require(:homework).permit(:admin_id, :manager_id, :tutor_id, :sub_tutor_id, :price, :additional, :internal_subject, :subject, :internal_deadline, :details, :priority, :tutor_price, :view_bidders, :login_school, :tutor_samples, :tutor_skills, :name, :min_bid).merge(deadline: deadline)
    else
      params.require(:homework).permit(:admin_id, :manager_id, :tutor_id, :sub_tutor_id, :price, :additional, :internal_subject, :subject, :internal_deadline, :details, :priority, :tutor_price, :view_bidders, :login_school, :tutor_samples, :tutor_skills, :name, :min_bid)
    end
  end
end
