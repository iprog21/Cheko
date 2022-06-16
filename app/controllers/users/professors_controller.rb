class Users::ProfessorsController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def show
    @professor = Professor.find(params[:id])
  end

  def new
  end

  def create
    
  end

  def search
    profs = Professor.where("LOWER(first_name) LIKE :search OR LOWER(last_name) LIKE :search", {search: "%#{params[:search].downcase}%"}).map{|prof| [prof.name, prof.id]}
    #.pluck(:first_name, :last_name)
    render json: {profs: profs}
  end

  private
  def professor_params
  end
end
