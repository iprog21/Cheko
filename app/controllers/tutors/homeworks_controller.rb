class Tutors::HomeworksController < ApplicationController
  before_action :authenticate_tutor!, except: [:upload]
  before_action :find_homework, except: [:index]
  
  def index
    @ongoing = Homework.where("tutor_id = ? AND status = 2", current_tutor.id).not_deleted
    @pending = Homework.where("tutor_id IS NULL AND status = 2", current_tutor.id).not_deleted
    @history = Homework.where("tutor_id = ? AND status = 3", current_tutor.id).not_deleted
    @for_admin_approval = Homework.where("tutor_id = ? AND status= 6", current_tutor.id).not_deleted
  end

  def show
    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)

    @documents = @homework.documents.where(documentable_type: "Tutor")
  end

  def edit
  end

  def upload
    @homework.documents.create(file: params[:document][:file], documentable_id: current_tutor.id, documentable_type: current_tutor.class.name)
    
    uploaded = @homework.documents.first.created_at.to_time
    deadline = @homework.internal_deadline.to_time
    hours = (deadline - uploaded) / 1.hours
    
    unless hours.to_i.positive?
      @homework.update(hours_late: hours)
    else
      @homework.update(hours_late: 0)
    end

    # HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "User")
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "NotifyAdmin")
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "NotifyTM")
    redirect_to tutors_homework_path(@homework.id)
  end

  def bid
    if @homework.bids.create(ammount: params[:ammount], tutor_id: current_tutor.id).valid?
      flash[:success] = "Bid successfully added."
    else
      flash[:alert] = "Bid amount exceeded!"
    end
    redirect_to tutors_homework_path(@homework)
  end

  def edit_bid
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)
  end

  def update_bid
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)
    if @bid.update(ammount: params[:ammount])
      redirect_to tutors_homework_path(@homework)
    end
  end


  def finish_homework
    @homework = Homework.find(params[:homework_id])
    @homework.update(status: "finished_by_tutor")
    flash[:success] = "Homework successfully submitted"

    redirect_to tutors_homework_path(params[:homework_id])
  end

  private
  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
