class Admins::HomeworksController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_homework, except: [:index]

  def index
    @homeworks = Homework.all
  end

  def show
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id])
  end
end
