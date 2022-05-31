class Managers::HomeworksController < ApplicationController
  before_action :authenticate_manager!
  before_action :find_homework, only: [:show]
  
  def index
    @homeworks = Homework.where(manager_id: current_manager.id)
  end

  def show

  end

  private
  def find_homework
    @homework = Homework.find(params[:id])
  end
end
