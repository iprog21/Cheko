class Users::HomeworksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_homework, except: [:index, :create, :new]
  
  def index
    @homeworks = current_user.homeworks
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id])
  end

  def homework_params
  end
end
