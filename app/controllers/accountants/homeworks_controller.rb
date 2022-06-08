class Accountants::HomeworksController < ApplicationController
  before_action :authenticate_accountant!
  
  def index
    @homeworks = Homework.all
  end
end
