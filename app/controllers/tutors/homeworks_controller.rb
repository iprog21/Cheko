class Tutors::HomeworksController < ApplicationController
  before_action :authenticate_tutor!
  before_action :find_homework, except: [:index]
  
  def index
    @homeworks = Homework.where("(tutor_id IS NULL OR tutor_id = ? )AND manager_id IS NOT NULL", current_tutor.id)
    # status: 'reviewing', tutor_id: nil
  end

  def show
    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)
  end

  def bid
    @homework.bids.create(ammount: params[:ammount], tutor_id: current_tutor.id)
    redirect_to tutors_homework_path(@homework)
  end

  def edit_bid
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)
  end

  def update_bid

  end

  private
  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
