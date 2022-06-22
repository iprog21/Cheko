class QualityOfficers::HomeworksController < ApplicationController
  before_action :authenticate_quality_officer!
  before_action :find_homework, except: [:index]

  def index
    @history = Homework.where(status: "done").order(created_at: :asc)
    @ongoing = Homework.where(status: "ongoing")
  end

  def show
  end

  def upload
  end

  private
  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
