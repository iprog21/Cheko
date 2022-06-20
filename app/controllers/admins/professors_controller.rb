class Admins::ProfessorsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_prof, except: [:index, :new, :create]

  def index
    @professors = Professor.all
    @pending = ProfReview.where(status: "pending")
  end

  def show
  end
  
  def new
    @professor = Professor.new
  end

  def create
    @professor = Professor.create(professor_params)
    redirect_to admins_professors_path
  end

  def edit
  end

  def update
    @professor.update(professor_params)
    redirect_to admins_professor_path(@professor)
  end

  def approve
  end

  def deny
  end

  def destroy
  end

  private

  def find_prof
    @professor = Professor.find(params[:id] || params[:professor_id])
  end

  def professor_params
    params.require(:professor).permit(:first_name, :last_name, :school, :easiness, :effectiveness, :life_changing, :light_workload, :leniency, :average, :a_able, :b_pls_able, :b_able, :c_able, :batch1_able, :batch2_able, :batch3_able, :batch4_able, :our_comments)
  end
end
